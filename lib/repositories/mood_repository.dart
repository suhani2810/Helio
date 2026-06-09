import 'package:isar/isar.dart';
import '../models/mood_entry_entity.dart';
import 'alarm_repository.dart';

class MoodRepository {
  final AlarmRepository _alarmRepo;

  MoodRepository(this._alarmRepo);

  Future<void> saveMood(MoodEntryEntity entry) async {
    final isar = await _alarmRepo.db;
    // Normalize date to midnight to ensure one entry per day
    entry.date = DateTime(entry.date.year, entry.date.month, entry.date.day);
    await isar.writeTxn(() async {
      await isar.moodEntryEntitys.put(entry);
    });
  }

  Future<MoodEntryEntity?> getTodayMood() async {
    final isar = await _alarmRepo.db;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return await isar.moodEntryEntitys.filter().dateEqualTo(today).findFirst();
  }

  Future<List<MoodEntryEntity>> getMoodHistory() async {
    final isar = await _alarmRepo.db;
    return await isar.moodEntryEntitys.where().sortByDateDesc().findAll();
  }

  Future<void> updateMood(MoodEntryEntity entry) async {
    await saveMood(entry);
  }
}
