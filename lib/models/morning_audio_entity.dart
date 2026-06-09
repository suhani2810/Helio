import 'package:isar/isar.dart';

part 'morning_audio_entity.g.dart';

@collection
class MorningAudioEntity {
  Id id = Isar.autoIncrement;
  
  String audioPath;
  bool isEnabled;
  String title;

  MorningAudioEntity({
    this.audioPath = 'assets/audio/morning_birds.mp3',
    this.isEnabled = true,
    this.title = 'Morning Birds',
  });
}
