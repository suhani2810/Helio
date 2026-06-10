import 'package:isar/isar.dart';

part 'alarm_entity.g.dart';

@collection
class AlarmEntity {
  Id id = Isar.autoIncrement;

  String label;
  DateTime alarmTime;
  bool enabled;
  List<int> repeatDays; // 0 = Monday, 6 = Sunday
  String ringtone;
  String missionType;
  bool followUpEnabled;
  int followUpMinutes;
  String followUpMission;
  DateTime createdAt;

  // Task 7: Mission Specific Settings
  int mathDifficulty; // 0=Easy, 1=Medium, 2=Hard
  int mathQuestionsCount;
  int shakeLimit;
  int stepGoal;
  int walkingDifficulty; // 0=Easy, 1=Medium, 2=Hard
  String targetObject;
  int puzzleSize; // 3 for 3x3, 4 for 4x4
  int puzzleDifficulty; // 0=Easy, 1=Medium, 2=Hard

  AlarmEntity({
    this.label = 'Alarm',
    required this.alarmTime,
    this.enabled = true,
    this.repeatDays = const [],
    this.ringtone = 'Default',
    this.missionType = 'None',
    this.followUpEnabled = false,
    this.followUpMinutes = 5,
    this.followUpMission = 'None',
    required this.createdAt,
    this.mathDifficulty = 1,
    this.mathQuestionsCount = 3,
    this.shakeLimit = 20,
    this.stepGoal = 30,
    this.walkingDifficulty = 1,
    this.targetObject = 'Mug',
    this.puzzleSize = 3,
    this.puzzleDifficulty = 1,
  });
}
