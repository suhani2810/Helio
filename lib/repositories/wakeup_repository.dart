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
}
