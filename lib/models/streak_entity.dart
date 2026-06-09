import 'package:isar/isar.dart';

part 'streak_entity.g.dart';

@collection
class StreakEntity {
  Id id = Isar.autoIncrement;
  
  int currentStreak;
  int bestStreak;
  DateTime? lastSuccessfulWakeup;

  StreakEntity({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastSuccessfulWakeup,
  });
}
