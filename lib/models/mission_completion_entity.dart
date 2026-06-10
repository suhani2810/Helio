import 'package:isar/isar.dart';

part 'mission_completion_entity.g.dart';

@collection
class MissionCompletionEntity {
  Id id = Isar.autoIncrement;
  
  String missionType;
  DateTime completedAt;
  bool success;
  
  int? mathDifficulty;
  int? mathQuestionsSolved;
  
  int? puzzleDifficulty;
  int? puzzleMistakes;
  int? puzzleCompletionTime;
  
  int? walkingStepsGoal;
  int? walkingStepsTaken;
  int? walkingCompletionTime;
  
  bool isFollowUp;

  MissionCompletionEntity({
    required this.missionType,
    required this.completedAt,
    this.success = true,
    this.mathDifficulty,
    this.mathQuestionsSolved,
    this.puzzleDifficulty,
    this.puzzleMistakes,
    this.puzzleCompletionTime,
    this.walkingStepsGoal,
    this.walkingStepsTaken,
    this.walkingCompletionTime,
    this.isFollowUp = false,
  });
}
