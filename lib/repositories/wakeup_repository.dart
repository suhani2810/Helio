import 'package:isar/isar.dart';
import '../models/wakeup_entity.dart';
import 'alarm_repository.dart';

class WakeupRepository {
  final AlarmRepository _alarmRepo;

  WakeupRepository(this._alarmRepo);

  Future<void> recordWakeup(WakeupEntity wakeup) async {
    final isar = await _alarmRepo.db;
    await isar.writeTxn(() async {
      await isar.wakeupEntitys.put(wakeup);
    });
  }

  Future<List<WakeupEntity>> getWakeupHistory() async {
    final isar = await _alarmRepo.db;
    return await isar.wakeupEntitys.where().sortByActualTimeDesc().findAll();
  }

  Future<double> getAverageConsistency() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return 0.0;
    
    // Consistency score: 100 - average delay minutes (max 100)
    double totalDelay = 0;
    for (var w in history) {
      totalDelay += w.delayMinutes;
    }
    double avgDelay = totalDelay / history.length;
    return (100 - avgDelay).clamp(0, 100).toDouble();
  }

  Future<double> getWeeklyWakeupScore() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return 0.0;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    final weeklyList = history.where((w) => w.actualTime.isAfter(sevenDaysAgo)).toList();
    if (weeklyList.isEmpty) return 0.0;

    double totalDelay = 0;
    for (var w in weeklyList) {
      totalDelay += w.delayMinutes;
    }
    double avgDelay = totalDelay / weeklyList.length;
    return (100 - avgDelay).clamp(0, 100).toDouble();
  }

  Future<double> getMonthlyWakeupScore() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return 0.0;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final monthlyList = history.where((w) => w.actualTime.isAfter(thirtyDaysAgo)).toList();
    if (monthlyList.isEmpty) return 0.0;

    double totalDelay = 0;
    for (var w in monthlyList) {
      totalDelay += w.delayMinutes;
    }
    double avgDelay = totalDelay / monthlyList.length;
    return (100 - avgDelay).clamp(0, 100).toDouble();
  }

  Future<String> getMostSuccessfulMission() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return 'None';
    
    final counts = <String, int>{};
    for (var w in history) {
      counts[w.missionUsed] = (counts[w.missionUsed] ?? 0) + 1;
    }
    
    var mostUsed = 'None';
    var maxCount = 0;
    counts.forEach((key, value) {
      if (value > maxCount) {
        maxCount = value;
        mostUsed = key;
      }
    });
    return mostUsed;
  }

  Future<double> getAverageWakeupDelay() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return 0.0;
    double totalDelay = 0.0;
    for (var w in history) {
      totalDelay += w.delayMinutes;
    }
    return totalDelay / history.length;
  }

  Future<String> getAverageWakeupTime() async {
    final history = await getWakeupHistory();
    if (history.isEmpty) return '--:--';
    int totalMinutes = 0;
    for (var w in history) {
      final time = w.actualTime;
      totalMinutes += time.hour * 60 + time.minute;
    }
    final avgMinutes = (totalMinutes / history.length).round();
    final hour = avgMinutes ~/ 60;
    final minute = avgMinutes % 60;
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    
    return '$displayHour:$displayMinute $period';
  }
}
