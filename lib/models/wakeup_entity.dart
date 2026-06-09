import 'package:isar/isar.dart';

part 'wakeup_entity.g.dart';

@collection
class WakeupEntity {
  Id id = Isar.autoIncrement;
  
  late DateTime scheduledTime;
  late DateTime actualTime;
  late int delayMinutes;
  late String missionUsed;
  late int dayOfWeek; // 1 = Mon, 7 = Sun

  WakeupEntity({
    required this.scheduledTime,
    required this.actualTime,
    required this.delayMinutes,
    required this.missionUsed,
    required this.dayOfWeek,
  });
}
