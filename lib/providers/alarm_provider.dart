import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/alarm.dart';
import '../repositories/alarm_repository.dart';

part 'alarm_provider.g.dart';

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  final _repository = AlarmRepository();

  @override
  Future<List<Alarm>> build() async {
    return _repository.getAllAlarms();
  }

  Future<void> addAlarm(Alarm alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveAlarm(alarm);
      return _repository.getAllAlarms();
    });
  }

  Future<void> updateAlarm(Alarm alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveAlarm(alarm);
      return _repository.getAllAlarms();
    });
  }

  Future<void> deleteAlarm(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteAlarm(id);
      return _repository.getAllAlarms();
    });
  }

  Future<void> toggleAlarm(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.toggleAlarm(id);
      return _repository.getAllAlarms();
    });
  }
}
