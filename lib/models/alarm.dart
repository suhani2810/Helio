import 'package:isar/isar.dart';

part 'alarm.g.dart';

@collection
class Alarm {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime time;
  late List<int> repeatDays; // 0 = Monday, 6 = Sunday
  late bool isEnabled;
  late String missionType;
  late String ringtone;
  late String theme;
  late bool followUpEnabled;
  late int followUpTime; // minutes
  late bool morningAudioEnabled;
  late String morningAudioId;

  Alarm({
    this.title = 'Alarm',
    required this.time,
    this.repeatDays = const [],
    this.isEnabled = true,
    this.missionType = 'None',
    this.ringtone = 'Default',
    this.theme = 'Sunrise',
    this.followUpEnabled = false,
    this.followUpTime = 5,
    this.morningAudioEnabled = false,
    this.morningAudioId = 'None',
  });
}
