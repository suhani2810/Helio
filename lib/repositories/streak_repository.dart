import 'package:isar/isar.dart';
import '../models/streak_entity.dart';
import 'alarm_repository.dart';

class StreakRepository {
  final AlarmRepository _alarmRepo;

  StreakRepository(this._alarmRepo);

  Future<StreakEntity> _getOrCreateStreak() async {
    final isar = await _alarmRepo.db;
    var streak = await isar.streakEntitys.where().findFirst();
    if (streak == null) {
      streak = StreakEntity(currentStreak: 0, bestStreak: 0);
      await isar.writeTxn(() async {
        await isar.streakEntitys.put(streak!);
      });
    }
    return streak;
  }

  Future<void> updateStreak() async {
    final isar = await _alarmRepo.db;
    final streak = await _getOrCreateStreak();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (streak.lastSuccessfulWakeup != null) {
      final last = DateTime(
        streak.lastSuccessfulWakeup!.year,
        streak.lastSuccessfulWakeup!.month,
        streak.lastSuccessfulWakeup!.day,
      );
      final diff = today.difference(last).inDays;

      if (diff == 1) {
        streak.currentStreak += 1;
      } else if (diff > 1) {
        streak.currentStreak = 1;
      }
      // If diff == 0, already updated today, do nothing or keep as is.
    } else {
      streak.currentStreak = 1;
    }

    if (streak.currentStreak > streak.bestStreak) {
      streak.bestStreak = streak.currentStreak;
    }
    streak.lastSuccessfulWakeup = now;

    await isar.writeTxn(() async {
      await isar.streakEntitys.put(streak);
    });
  }

  Future<void> resetStreak() async {
    final isar = await _alarmRepo.db;
    final streak = await _getOrCreateStreak();
    streak.currentStreak = 0;
    await isar.writeTxn(() async {
      await isar.streakEntitys.put(streak);
    });
  }

  Future<int> getCurrentStreak() async {
    final streak = await _getOrCreateStreak();
    return streak.currentStreak;
  }

  Future<int> getBestStreak() async {
    final streak = await _getOrCreateStreak();
    return streak.bestStreak;
  }
}
