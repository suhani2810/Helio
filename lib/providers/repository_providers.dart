import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/alarm_repository.dart';
import '../repositories/mood_repository.dart';
import '../repositories/streak_repository.dart';
import '../repositories/mission_analytics_repository.dart';
import '../repositories/wakeup_repository.dart';
import '../repositories/morning_audio_repository.dart';
import '../core/services/alarm_scheduler_service.dart';

part 'repository_providers.g.dart';

@riverpod
AlarmRepository alarmRepository(AlarmRepositoryRef ref) {
  return AlarmRepository();
}

@riverpod
MoodRepository moodRepository(MoodRepositoryRef ref) {
  final alarmRepo = ref.watch(alarmRepositoryProvider);
  return MoodRepository(alarmRepo);
}

@riverpod
StreakRepository streakRepository(StreakRepositoryRef ref) {
  final alarmRepo = ref.watch(alarmRepositoryProvider);
  return StreakRepository(alarmRepo);
}

@riverpod
MissionAnalyticsRepository missionAnalyticsRepository(MissionAnalyticsRepositoryRef ref) {
  final alarmRepo = ref.watch(alarmRepositoryProvider);
  return MissionAnalyticsRepository(alarmRepo);
}

@riverpod
WakeupRepository wakeupRepository(WakeupRepositoryRef ref) {
  final alarmRepo = ref.watch(alarmRepositoryProvider);
  return WakeupRepository(alarmRepo);
}

@riverpod
MorningAudioRepository morningAudioRepository(MorningAudioRepositoryRef ref) {
  final alarmRepo = ref.watch(alarmRepositoryProvider);
  return MorningAudioRepository(alarmRepo);
}

@riverpod
AlarmSchedulerService alarmSchedulerService(AlarmSchedulerServiceRef ref) {
  return AlarmSchedulerService();
}
