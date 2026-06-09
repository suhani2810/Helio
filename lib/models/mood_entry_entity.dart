import 'package:isar/isar.dart';

part 'mood_entry_entity.g.dart';

@collection
class MoodEntryEntity {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  DateTime date; // Normalized date (midnight) for daily mood
  
  String mood; // Great, Good, Neutral, Low, Exhausted
  String? note;

  MoodEntryEntity({
    required this.date,
    required this.mood,
    this.note,
  });
}
