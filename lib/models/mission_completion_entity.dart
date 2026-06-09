import 'package:isar/isar.dart';

part 'mission_completion_entity.g.dart';

@collection
class MissionCompletionEntity {
  Id id = Isar.autoIncrement;
  
  String missionType;
  DateTime completedAt;
  bool success;

  MissionCompletionEntity({
    required this.missionType,
    required this.completedAt,
    this.success = true,
  });
}
