import 'package:isar/isar.dart';
import '../models/mood_entry_entity.dart';
import 'alarm_repository.dart';

class MoodRepository {
  final AlarmRepository _alarmRepo;

  MoodRepository(this._alarmRepo);

  Future<void> saveMood(MoodEntryEntity entry) async {
    final isar = await _alarmRepo.db;
    // Normalize date to midnight to ensure one entry per day
    final normalizedDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
    entry.date = normalizedDate;
    
    await isar.writeTxn(() async {
      final existing = await isar.moodEntryEntitys.filter().dateEqualTo(normalizedDate).findFirst();
      if (existing != null) {
        entry.id = existing.id;
      }
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

  Future<List<double>> getLast7DaysMoodTrend() async {
    final history = await getMoodHistory();
    final now = DateTime.now();
    final trend = <double>[];
    
    final moodValueMap = {
      'Energized': 1.0,
      'Happy': 0.8,
      'Calm': 0.6,
      'Tired': 0.4,
      'Stressed': 0.2,
    };
    
    for (int i = 6; i >= 0; i--) {
      final dateToCheck = now.subtract(Duration(days: i));
      final dateNormalized = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
      
      MoodEntryEntity? matchedEntry;
      for (var entry in history) {
        if (entry.date.year == dateNormalized.year &&
            entry.date.month == dateNormalized.month &&
            entry.date.day == dateNormalized.day) {
          matchedEntry = entry;
          break;
        }
      }
      
      if (matchedEntry != null) {
        trend.add(moodValueMap[matchedEntry.mood] ?? 0.0);
      } else {
        trend.add(0.0); // No entry for this day
      }
    }
    return trend;
  }

  Future<String> getMostCommonMood() async {
    final history = await getMoodHistory();
    if (history.isEmpty) return 'None';
    final counts = <String, int>{};
    for (var entry in history) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    var mostCommon = 'None';
    var maxCount = 0;
    counts.forEach((key, value) {
      if (value > maxCount) {
        maxCount = value;
        mostCommon = key;
      }
    });
    return mostCommon;
  }
}
