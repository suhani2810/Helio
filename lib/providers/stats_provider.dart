import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';
import '../models/mood_entry_entity.dart';
import '../models/wakeup_entity.dart';
import 'alarm_provider.dart';

part 'stats_provider.g.dart';

@riverpod
Future<List<double>> moodTrend(MoodTrendRef ref) async {
  return ref.watch(moodRepositoryProvider).getLast7DaysMoodTrend();
}

@riverpod
class MoodNotifier extends _$MoodNotifier {
  @override
  Future<MoodEntryEntity?> build() async {
    return ref.watch(moodRepositoryProvider).getTodayMood();
  }

  Future<void> setMood(String mood, {String? note}) async {
    final entry = MoodEntryEntity(date: DateTime.now(), mood: mood, note: note);
    await ref.read(moodRepositoryProvider).saveMood(entry);
    ref.invalidateSelf();
    ref.invalidate(moodTrendProvider);
    ref.invalidate(moodLogsCountProvider);
    ref.invalidate(mostCommonMoodProvider);
    ref.invalidate(circadianScoreProvider);
    ref.invalidate(moodHistoryProvider);
  }
}

@riverpod
class StreakNotifier extends _$StreakNotifier {
  @override
  Future<int> build() async {
    return ref.watch(streakRepositoryProvider).getCurrentStreak();
  }

  Future<void> incrementStreak() async {
    await ref.read(streakRepositoryProvider).updateStreak();
    ref.invalidateSelf();
    ref.invalidate(bestStreakProvider);
  }
}

@riverpod
Future<int> bestStreak(BestStreakRef ref) async {
  return ref.watch(streakRepositoryProvider).getBestStreak();
}

@riverpod
Future<Map<String, int>> missionStats(MissionStatsRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getMissionStats();
}

@riverpod
Future<int> totalWakeups(TotalWakeupsRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getTotalWakeups();
}

@riverpod
Future<double> wakeupConsistency(WakeupConsistencyRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getAverageConsistency();
}

@riverpod
Future<String> mostUsedMission(MostUsedMissionRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getMostSuccessfulMission();
}

@riverpod
Future<List<WakeupEntity>> wakeupHistory(WakeupHistoryRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getWakeupHistory();
}

@riverpod
Future<int> totalAlarmsCreated(TotalAlarmsCreatedRef ref) async {
  final alarms = await ref.watch(alarmNotifierProvider.future);
  return alarms.length;
}

@riverpod
Future<int> activeAlarmsCount(ActiveAlarmsCountRef ref) async {
  final alarms = await ref.watch(alarmNotifierProvider.future);
  return alarms.where((a) => a.enabled).length;
}

@riverpod
Future<int> completedMissions(CompletedMissionsRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getTotalWakeups();
}

@riverpod
Future<int> moodLogsCount(MoodLogsCountRef ref) async {
  final history = await ref.watch(moodRepositoryProvider).getMoodHistory();
  return history.length;
}

@riverpod
Future<double> averageWakeupDelay(AverageWakeupDelayRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getAverageWakeupDelay();
}

@riverpod
Future<int> followUpAlarmsCompleted(FollowUpAlarmsCompletedRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getFollowUpCompletionsCount();
}

@riverpod
Future<double> missionCompletionRate(MissionCompletionRateRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getMissionCompletionRate();
}

@riverpod
Future<double> averageMissionDuration(AverageMissionDurationRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getAverageMissionDuration();
}

@riverpod
Future<String> mostCommonMood(MostCommonMoodRef ref) async {
  return ref.watch(moodRepositoryProvider).getMostCommonMood();
}

@riverpod
Future<String> averageWakeupTime(AverageWakeupTimeRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getAverageWakeupTime();
}

@riverpod
Future<double> averageAlarmDelay(AverageAlarmDelayRef ref) async {
  return ref.watch(wakeupRepositoryProvider).getAverageWakeupDelay();
}

@riverpod
Future<int> totalSuccessfulWakeups(TotalSuccessfulWakeupsRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getTotalWakeups();
}

@riverpod
Future<int> missedAlarmsCount(MissedAlarmsCountRef ref) async {
  return ref.watch(missionAnalyticsRepositoryProvider).getMissedAlarmsCount();
}

@riverpod
Future<int> activityGoalTarget(ActivityGoalTargetRef ref) async {
  final success = await ref.watch(totalWakeupsProvider.future);
  final missed = await ref.watch(missedAlarmsCountProvider.future);
  final total = success + missed;
  
  if (total <= 10) return 10;
  if (total <= 25) return 25;
  if (total <= 50) return 50;
  if (total <= 100) return 100;
  if (total <= 250) return 250;
  if (total <= 500) return 500;
  return 1000;
}

@riverpod
Future<double> circadianScore(CircadianScoreRef ref) async {
  final consistency = await ref.watch(wakeupConsistencyProvider.future);
  final missedCount = await ref.watch(missedAlarmsCountProvider.future);
  final successfulCount = await ref.watch(totalWakeupsProvider.future);
  final totalCompletions = successfulCount + missedCount;

  double successFactor = 1.0;
  if (totalCompletions > 0) {
    successFactor = successfulCount / totalCompletions;
  }

  // Get mood trend from code-generated provider or fall back
  final trend = await ref.watch(moodTrendProvider.future);
  double moodFactor = 0.0;
  if (trend.isNotEmpty) {
    final activeMoods = trend.where((m) => m > 0.0).toList();
    if (activeMoods.isNotEmpty) {
      final avgMood = activeMoods.reduce((a, b) => a + b) / activeMoods.length;
      moodFactor = (avgMood - 0.6) * 20.0; // Boost up to +8, penalty down to -8
    }
  }

  final score = consistency * successFactor + moodFactor;

  final history = await ref.watch(wakeupHistoryProvider.future);
  if (history.isEmpty) {
    return 0.0;
  }
  
  return score.clamp(0.0, 100.0);
}

@riverpod
Future<List<MoodEntryEntity>> moodHistory(MoodHistoryRef ref) async {
  return ref.watch(moodRepositoryProvider).getMoodHistory();
}

@riverpod
Future<double> averageMoodScore(AverageMoodScoreRef ref) async {
  final history = await ref.watch(moodHistoryProvider.future);
  if (history.isEmpty) return 0.0;
  
  final moodValueMap = {
    'Energized': 5,
    'Happy': 4,
    'Calm': 3,
    'Tired': 2,
    'Stressed': 1,
    'Great': 5,
    'Good': 4,
    'Neutral': 3,
    'Low': 2,
    'Exhausted': 1,
  };
  
  final total = history.fold(0, (sum, entry) => sum + (moodValueMap[entry.mood] ?? 0));
  return total / history.length;
}

@riverpod
Future<String> highestMood(HighestMoodRef ref) async {
  final history = await ref.watch(moodHistoryProvider.future);
  if (history.isEmpty) return '—';
  
  final moodValueMap = {
    'Energized': 5,
    'Happy': 4,
    'Calm': 3,
    'Tired': 2,
    'Stressed': 1,
    'Great': 5,
    'Good': 4,
    'Neutral': 3,
    'Low': 2,
    'Exhausted': 1,
  };
  
  var highest = -1;
  var mood = '—';
  
  for (var entry in history) {
    final val = moodValueMap[entry.mood] ?? 0;
    if (val > highest) {
      highest = val;
      mood = entry.mood;
    }
  }
  return mood;
}

@riverpod
Future<String> lowestMood(LowestMoodRef ref) async {
  final history = await ref.watch(moodHistoryProvider.future);
  if (history.isEmpty) return '—';
  
  final moodValueMap = {
    'Energized': 5,
    'Happy': 4,
    'Calm': 3,
    'Tired': 2,
    'Stressed': 1,
    'Great': 5,
    'Good': 4,
    'Neutral': 3,
    'Low': 2,
    'Exhausted': 1,
  };
  
  var lowest = 6;
  var mood = '—';
  
  for (var entry in history) {
    final val = moodValueMap[entry.mood] ?? 0;
    if (val < lowest) {
      lowest = val;
      mood = entry.mood;
    }
  }
  return mood;
}

@riverpod
Future<String> moodTrendLabel(MoodTrendLabelRef ref) async {
  final trend = await ref.watch(moodTrendProvider.future);
  if (trend.length < 2) return 'Stable';
  
  final recent = trend.sublist(trend.length - 2);
  if (recent[1] > recent[0]) return 'Rising';
  if (recent[1] < recent[0]) return 'Falling';
  return 'Stable';
}

@riverpod
Future<Map<String, dynamic>> userRank(UserRankRef ref) async {
  final wakeups = await ref.watch(totalSuccessfulWakeupsProvider.future);
  
  String title;
  int nextGoal;
  
  if (wakeups < 5) {
    title = 'Beginner';
    nextGoal = 5;
  } else if (wakeups < 15) {
    title = 'Early Riser';
    nextGoal = 15;
  } else if (wakeups < 30) {
    title = 'Phoenix';
    nextGoal = 30;
  } else if (wakeups < 60) {
    title = 'Sunrise Master';
    nextGoal = 60;
  } else {
    title = 'Dawn Legend';
    nextGoal = 100; // Cap
  }
  
  return {
    'title': title,
    'wakeups': wakeups,
    'nextGoal': nextGoal,
    'progress': wakeups / nextGoal,
  };
}

@riverpod
Future<List<Map<String, dynamic>>> achievements(AchievementsRef ref) async {
  final wakeups = await ref.watch(totalSuccessfulWakeupsProvider.future);
  final streak = await ref.watch(streakNotifierProvider.future);
  final moodLogs = await ref.watch(moodLogsCountProvider.future);
  final missionStats = await ref.watch(missionStatsProvider.future);
  
  final mathCompleted = missionStats['Math'] ?? 0;
  final puzzleCompleted = missionStats['Tile Puzzle'] ?? 0;

  // Find completion dates for achievements
  final completions = await ref.watch(missionAnalyticsRepositoryProvider).getRecentCompletions(100);
  final successfulCompletions = completions.where((c) => c.success).toList();
  
  DateTime? firstWakeupDate;
  if (successfulCompletions.isNotEmpty) {
    firstWakeupDate = successfulCompletions.last.completedAt; // last because sorted desc
  }

  DateTime? earlyBirdDate;
  if (wakeups >= 30 && successfulCompletions.length >= 30) {
    earlyBirdDate = successfulCompletions[successfulCompletions.length - 30].completedAt;
  }
  
  return [
    {
      'id': 'first_wakeup',
      'title': 'First Wakeup',
      'description': 'Complete 1 alarm',
      'icon': Icons.wb_sunny_rounded,
      'isUnlocked': wakeups >= 1,
      'progress': wakeups >= 1 ? 1.0 : wakeups / 1,
      'unlockedAt': firstWakeupDate,
    },
    {
      'id': 'week_warrior',
      'title': 'Week Warrior',
      'description': '7-day streak',
      'icon': Icons.local_fire_department_rounded,
      'isUnlocked': streak >= 7,
      'progress': streak >= 7 ? 1.0 : streak / 7,
      'unlockedAt': streak >= 7 ? DateTime.now() : null, // Approx
    },
    {
      'id': 'math_master',
      'title': 'Math Master',
      'description': 'Complete 25 math missions',
      'icon': Icons.calculate_rounded,
      'isUnlocked': mathCompleted >= 25,
      'progress': mathCompleted >= 25 ? 1.0 : mathCompleted / 25,
      'unlockedAt': mathCompleted >= 25 ? DateTime.now() : null,
    },
    {
      'id': 'puzzle_expert',
      'title': 'Puzzle Expert',
      'description': 'Complete 25 puzzle missions',
      'icon': Icons.extension_rounded,
      'isUnlocked': puzzleCompleted >= 25,
      'progress': puzzleCompleted >= 25 ? 1.0 : puzzleCompleted / 25,
      'unlockedAt': puzzleCompleted >= 25 ? DateTime.now() : null,
    },
    {
      'id': 'mood_tracker',
      'title': 'Mood Tracker',
      'description': 'Log mood 14 days',
      'icon': Icons.mood_rounded,
      'isUnlocked': moodLogs >= 14,
      'progress': moodLogs >= 14 ? 1.0 : moodLogs / 14,
      'unlockedAt': moodLogs >= 14 ? DateTime.now() : null,
    },
    {
      'id': 'early_bird',
      'title': 'Early Bird',
      'description': '30 successful wakeups',
      'icon': Icons.wb_twilight_rounded,
      'isUnlocked': wakeups >= 30,
      'progress': wakeups >= 30 ? 1.0 : wakeups / 30,
      'unlockedAt': earlyBirdDate,
    },
  ];
}

@riverpod
Future<MoodEntryEntity?> latestMoodEntry(LatestMoodEntryRef ref) async {
  final history = await ref.watch(moodHistoryProvider.future);
  if (history.isEmpty) return null;
  return history.first; // sorted desc by date
}

@riverpod
Future<String> moodStatus(MoodStatusRef ref) async {
  final latest = await ref.watch(latestMoodEntryProvider.future);
  if (latest == null) return 'Not Set';
  
  switch (latest.mood) {
    case 'Happy':
    case 'Great':
    case 'Good':
      return 'Positive';
    case 'Calm':
    case 'Neutral':
      return 'Balanced';
    case 'Tired':
    case 'Exhausted':
    case 'Low':
      return 'Low Energy';
    case 'Stressed':
      return 'Low';
    case 'Energized':
      return 'High Energy';
    default:
      return 'Stable';
  }
}

void invalidateAllStats(Ref ref) {
  ref.invalidate(streakNotifierProvider);
  ref.invalidate(bestStreakProvider);
  ref.invalidate(wakeupHistoryProvider);
  ref.invalidate(wakeupConsistencyProvider);
  ref.invalidate(mostUsedMissionProvider);
  ref.invalidate(totalWakeupsProvider);
  ref.invalidate(missionStatsProvider);
  ref.invalidate(completedMissionsProvider);
  ref.invalidate(moodLogsCountProvider);
  ref.invalidate(averageWakeupDelayProvider);
  ref.invalidate(followUpAlarmsCompletedProvider);
  ref.invalidate(missionCompletionRateProvider);
  ref.invalidate(averageMissionDurationProvider);
  ref.invalidate(mostCommonMoodProvider);
  ref.invalidate(averageWakeupTimeProvider);
  ref.invalidate(averageAlarmDelayProvider);
  ref.invalidate(totalSuccessfulWakeupsProvider);
  ref.invalidate(missedAlarmsCountProvider);
  ref.invalidate(activityGoalTargetProvider);
  ref.invalidate(circadianScoreProvider);
  ref.invalidate(moodTrendProvider);
  ref.invalidate(moodHistoryProvider);
  ref.invalidate(latestMoodEntryProvider);
  ref.invalidate(moodStatusProvider);
  ref.invalidate(userRankProvider);
  ref.invalidate(achievementsProvider);
  ref.invalidate(averageMoodScoreProvider);
  ref.invalidate(highestMoodProvider);
  ref.invalidate(lowestMoodProvider);
  ref.invalidate(moodTrendLabelProvider);
}
