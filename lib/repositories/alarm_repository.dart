import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/alarm_entity.dart';
import '../models/mood_entry_entity.dart';
import '../models/streak_entity.dart';
import '../models/mission_completion_entity.dart';
import '../models/wakeup_entity.dart';
import '../models/morning_audio_entity.dart';

class AlarmRepository {
  late Future<Isar> db;

  AlarmRepository() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          AlarmEntitySchema,
          MoodEntryEntitySchema,
          StreakEntitySchema,
          MissionCompletionEntitySchema,
          WakeupEntitySchema,
          MorningAudioEntitySchema,
        ],
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  Future<List<AlarmEntity>> getAllAlarms() async {
    final isar = await db;
    return await isar.alarmEntitys.where().findAll();
  }

  Future<AlarmEntity?> getAlarm(Id id) async {
    final isar = await db;
    return await isar.alarmEntitys.get(id);
  }

  Future<void> saveAlarm(AlarmEntity alarm) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.alarmEntitys.put(alarm);
    });
  }

  Future<void> deleteAlarm(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.alarmEntitys.delete(id);
    });
  }

  Future<void> toggleAlarm(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final alarm = await isar.alarmEntitys.get(id);
      if (alarm != null) {
        alarm.enabled = !alarm.enabled;
        await isar.alarmEntitys.put(alarm);
      }
    });
  }
}
