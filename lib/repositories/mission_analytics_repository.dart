import 'package:isar/isar.dart';
import '../models/mission_completion_entity.dart';
import 'alarm_repository.dart';

class MissionAnalyticsRepository {
  final AlarmRepository _alarmRepo;
  bool _isSyncing = false;

  MissionAnalyticsRepository(this._alarmRepo);

  Future<void> recordCompletion(
    String missionType,
    bool success, {
    int? mathDifficulty,
    int? mathQuestionsSolved,
    int? puzzleDifficulty,
    int? puzzleMistakes,
    int? puzzleCompletionTime,
    int? walkingStepsGoal,
    int? walkingStepsTaken,
    int? walkingCompletionTime,
    bool isFollowUp = false,
    DateTime? completedAt,
  }) async {
    final isar = await _alarmRepo.db;
    final completion = MissionCompletionEntity(
      missionType: missionType,
      completedAt: completedAt ?? DateTime.now(),
      success: success,
      mathDifficulty: mathDifficulty,
      mathQuestionsSolved: mathQuestionsSolved,
      puzzleDifficulty: puzzleDifficulty,
      puzzleMistakes: puzzleMistakes,
      puzzleCompletionTime: puzzleCompletionTime,
      walkingStepsGoal: walkingStepsGoal,
      walkingStepsTaken: walkingStepsTaken,
      walkingCompletionTime: walkingCompletionTime,
      isFollowUp: isFollowUp,
    );
    await isar.writeTxn(() async {
      await isar.missionCompletionEntitys.put(completion);
    });
  }

  Future<void> syncMissedAlarms() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final isar = await _alarmRepo.db;
      final alarms = await _alarmRepo.getAllAlarms();
      final now = DateTime.now();
      
      // Check occurrences in the last 7 days
      final checkStart = now.subtract(const Duration(days: 7));
      // Exclude occurrences in the last 30 minutes (grace period)
      final endLimit = now.subtract(const Duration(minutes: 30));

      for (final alarm in alarms) {
        if (!alarm.enabled) continue;
        
        final startLimit = alarm.createdAt.isAfter(checkStart) ? alarm.createdAt : checkStart;
        if (startLimit.isAfter(endLimit)) continue;

        if (alarm.repeatDays.isEmpty) {
          // One-time alarm
          final occurrence = DateTime(
            alarm.alarmTime.year,
            alarm.alarmTime.month,
            alarm.alarmTime.day,
            alarm.alarmTime.hour,
            alarm.alarmTime.minute,
          );
          if (occurrence.isAfter(startLimit) && occurrence.isBefore(endLimit)) {
            final completionExists = await _hasCompletionInRange(isar, occurrence);
            if (!completionExists) {
              await recordCompletion(
                alarm.missionType,
                false,
                completedAt: occurrence,
              );
            }
          }
        } else {
          // Repeat alarm
          var checkDay = DateTime(startLimit.year, startLimit.month, startLimit.day);
          final endDay = DateTime(endLimit.year, endLimit.month, endLimit.day);
          
          while (checkDay.isBefore(endDay) || checkDay.isAtSameMomentAs(endDay)) {
            final isarWeekday = checkDay.weekday - 1; // 0=Mon, 6=Sun
            if (alarm.repeatDays.contains(isarWeekday)) {
              final occurrence = DateTime(
                checkDay.year,
                checkDay.month,
                checkDay.day,
                alarm.alarmTime.hour,
                alarm.alarmTime.minute,
              );
              if (occurrence.isAfter(startLimit) && occurrence.isBefore(endLimit)) {
                final completionExists = await _hasCompletionInRange(isar, occurrence);
                if (!completionExists) {
                  await recordCompletion(
                    alarm.missionType,
                    false,
                    completedAt: occurrence,
                  );
                }
              }
            }
            checkDay = checkDay.add(const Duration(days: 1));
          }
        }
      }
    } catch (e) {
      print('Error in syncMissedAlarms: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _hasCompletionInRange(Isar isar, DateTime occurrence) async {
    final start = occurrence.subtract(const Duration(minutes: 5));
    final end = occurrence.add(const Duration(minutes: 30));
    final count = await isar.missionCompletionEntitys
        .filter()
        .completedAtBetween(start, end)
        .count();
    return count > 0;
  }

  Future<int> getCompletionCount(String missionType) async {
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys
        .filter()
        .missionTypeEqualTo(missionType)
        .and()
        .successEqualTo(true)
        .count();
  }

  Future<Map<String, int>> getMissionStats() async {
    final isar = await _alarmRepo.db;
    final all = await isar.missionCompletionEntitys.filter().successEqualTo(true).findAll();
    final stats = <String, int>{};
    for (var m in all) {
      stats[m.missionType] = (stats[m.missionType] ?? 0) + 1;
    }
    return stats;
  }

  Future<int> getTotalWakeups() async {
    await syncMissedAlarms();
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys.filter().successEqualTo(true).count();
  }

  Future<int> getFollowUpCompletionsCount() async {
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys.filter().isFollowUpEqualTo(true).count();
  }

  Future<double> getAverageMissionDuration() async {
    final isar = await _alarmRepo.db;
    final completions = await isar.missionCompletionEntitys.where().findAll();
    double totalSeconds = 0;
    int count = 0;
    for (var c in completions) {
      if (c.puzzleCompletionTime != null) {
        totalSeconds += c.puzzleCompletionTime!;
        count++;
      }
      if (c.walkingCompletionTime != null) {
        totalSeconds += c.walkingCompletionTime!;
        count++;
      }
    }
    return count > 0 ? totalSeconds / count : 0.0;
  }

  Future<double> getMissionCompletionRate() async {
    await syncMissedAlarms();
    final isar = await _alarmRepo.db;
    final total = await isar.missionCompletionEntitys.count();
    if (total == 0) return 100.0;
    final success = await isar.missionCompletionEntitys.filter().successEqualTo(true).count();
    return (success / total) * 100.0;
  }

  Future<int> getMissedAlarmsCount() async {
    await syncMissedAlarms();
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys.filter().successEqualTo(false).count();
  }

  Future<List<MissionCompletionEntity>> getRecentCompletions(int limit) async {
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys.where().sortByCompletedAtDesc().limit(limit).findAll();
  }
}
