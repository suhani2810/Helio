import 'package:isar/isar.dart';
import '../models/morning_audio_entity.dart';
import 'alarm_repository.dart';

class MorningAudioRepository {
  final AlarmRepository _alarmRepo;

  MorningAudioRepository(this._alarmRepo);

  Future<MorningAudioEntity> getSettings() async {
    final isar = await _alarmRepo.db;
    var settings = await isar.morningAudioEntitys.where().findFirst();
    if (settings == null) {
      settings = MorningAudioEntity();
      await isar.writeTxn(() async {
        await isar.morningAudioEntitys.put(settings!);
      });
    }
    return settings;
  }

  Future<void> updateSettings(MorningAudioEntity settings) async {
    final isar = await _alarmRepo.db;
    await isar.writeTxn(() async {
      await isar.morningAudioEntitys.put(settings);
    });
  }
}
