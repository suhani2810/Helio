import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_providers.dart';
import '../models/mood_entry_entity.dart';
import '../models/wakeup_entity.dart';

part 'stats_provider.g.dart';

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
