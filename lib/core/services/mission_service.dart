import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../providers/repository_providers.dart';
import '../../providers/stats_provider.dart';
import '../../providers/alarm_provider.dart';
import '../../models/wakeup_entity.dart';
import '../../models/alarm_entity.dart';
import 'notification_service.dart';
import 'ringtone_service.dart';

class MissionService {
  final Ref ref;
  static AudioPlayer? _audioPlayer;

  MissionService(this.ref);

  Future<void> completeMission({
    required String missionType,
    required DateTime scheduledTime,
    AlarmEntity? alarm,
    int? mathDifficulty,
    int? mathQuestionsSolved,
    int? puzzleDifficulty,
    int? puzzleMistakes,
    int? puzzleCompletionTime,
    int? walkingStepsGoal,
    int? walkingStepsTaken,
    int? walkingCompletionTime,
  }) async {
    // Stop the ringtone
    await RingtoneService.stop();

    // 1. Stop the alarm
    if (alarm != null) {
      await Alarm.stop(alarm.id);
    } else {
      final alarms = await Alarm.getAlarms();
      for (final a in alarms) {
        if (await Alarm.isRinging(a.id)) {
          await Alarm.stop(a.id);
        }
      }
    }

    // 2. Handle alarm cleanup or database state updates
    if (alarm != null) {
      if (alarm.label.startsWith('Follow-up:') || alarm.label.startsWith('Snooze:') || alarm.label.startsWith('DEV-TEST:')) {
        // Delete temporary alarm
        await ref.read(alarmRepositoryProvider).deleteAlarm(alarm.id);
      } else {
        // If it's a one-time alarm, disable it
        if (alarm.repeatDays.isEmpty) {
          alarm.enabled = false;
          await ref.read(alarmRepositoryProvider).saveAlarm(alarm);
        }
      }
    }

    // Reschedule next instances of other alarms
    ref.invalidate(alarmNotifierProvider);
    invalidateAllStats(ref);

    // 3. Record Wakeup Analytics
    final now = DateTime.now();
    final delay = now.difference(scheduledTime).inMinutes.clamp(0, 1440);
    
    final wakeup = WakeupEntity(
      scheduledTime: scheduledTime,
      actualTime: now,
      delayMinutes: delay,
      missionUsed: missionType,
      dayOfWeek: now.weekday,
    );
    
    await ref.read(wakeupRepositoryProvider).recordWakeup(wakeup);

    // 4. Update Streak
    await ref.read(streakNotifierProvider.notifier).incrementStreak();

    // 5. Record Mission Success
    await ref.read(missionAnalyticsRepositoryProvider).recordCompletion(
      missionType,
      true,
      mathDifficulty: mathDifficulty,
      mathQuestionsSolved: mathQuestionsSolved,
      puzzleDifficulty: puzzleDifficulty,
      puzzleMistakes: puzzleMistakes,
      puzzleCompletionTime: puzzleCompletionTime,
      walkingStepsGoal: walkingStepsGoal,
      walkingStepsTaken: walkingStepsTaken,
      walkingCompletionTime: walkingCompletionTime,
      isFollowUp: alarm != null && alarm.label.startsWith('Follow-up:'),
    );
    
    // 6. Handle Morning Audio
    final audioSettings = await ref.read(morningAudioRepositoryProvider).getSettings();
    if (audioSettings.isEnabled) {
      try {
        if (_audioPlayer != null) {
          await _audioPlayer!.stop();
        } else {
          _audioPlayer = AudioPlayer();
        }
        final assetPath = audioSettings.audioPath.replaceFirst('assets/', '');
        await _audioPlayer!.play(AssetSource(assetPath));
      } catch (e) {
        // Silent catch for audio playing failures in dev environment
      }
    }

    // 7. Trigger follow-up alarm if configured
    if (alarm != null && alarm.followUpEnabled && !alarm.label.startsWith('Follow-up:')) {
      final followUpTime = DateTime.now().add(Duration(minutes: alarm.followUpMinutes));
      final followUpAlarm = AlarmEntity(
        label: 'Follow-up: ${alarm.label}',
        alarmTime: followUpTime,
        enabled: true,
        repeatDays: const [],
        ringtone: alarm.ringtone,
        missionType: alarm.followUpMission,
        followUpEnabled: false, // Avoid infinite nesting
        createdAt: DateTime.now(),
        mathDifficulty: alarm.mathDifficulty,
        puzzleDifficulty: alarm.puzzleDifficulty,
        puzzleSize: alarm.puzzleSize,
        shakeLimit: alarm.shakeLimit,
        stepGoal: alarm.stepGoal,
        walkingDifficulty: alarm.walkingDifficulty,
        targetObject: alarm.targetObject,
      );

      // Save to local database
      await ref.read(alarmRepositoryProvider).saveAlarm(followUpAlarm);
      // Schedule with alarm package
      await ref.read(alarmSchedulerServiceProvider).scheduleAlarm(followUpAlarm);
      // Show local reminder notification
      await NotificationService().showNotification(
        id: followUpAlarm.id,
        title: 'Follow-up Alarm Set',
        body: 'You completed your wake-up mission, but a follow-up alarm is set for ${alarm.followUpMinutes} min from now.',
      );
    }
  }

  // Stop any playing morning audio (e.g. when app minimized or user stops manually)
  static Future<void> stopMorningAudio() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
  }
}

final missionServiceProvider = Provider((ref) => MissionService(ref));
