import 'package:isar/isar.dart';
import '../models/mission_completion_entity.dart';
import 'alarm_repository.dart';

class MissionAnalyticsRepository {
  final AlarmRepository _alarmRepo;

  MissionAnalyticsRepository(this._alarmRepo);

  Future<void> recordCompletion(String missionType, bool success) async {
    final isar = await _alarmRepo.db;
    final completion = MissionCompletionEntity(
      missionType: missionType,
      completedAt: DateTime.now(),
      success: success,
    );
    await isar.writeTxn(() async {
      await isar.missionCompletionEntitys.put(completion);
    });
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
    final isar = await _alarmRepo.db;
    return await isar.missionCompletionEntitys.filter().successEqualTo(true).count();
  }
}
