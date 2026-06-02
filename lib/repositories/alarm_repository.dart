import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/alarm.dart';

class AlarmRepository {
  late Future<Isar> db;

  AlarmRepository() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [AlarmSchema],
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  Future<List<Alarm>> getAllAlarms() async {
    final isar = await db;
    return await isar.alarms.where().findAll();
  }

  Future<void> saveAlarm(Alarm alarm) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.alarms.put(alarm);
    });
  }

  Future<void> deleteAlarm(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.alarms.delete(id);
    });
  }

  Future<void> toggleAlarm(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final alarm = await isar.alarms.get(id);
      if (alarm != null) {
        alarm.isEnabled = !alarm.isEnabled;
        await isar.alarms.put(alarm);
      }
    });
  }
}
