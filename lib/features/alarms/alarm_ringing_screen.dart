import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:alarm/alarm.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../models/alarm_entity.dart';
import '../../providers/time_provider.dart';
import '../../providers/repository_providers.dart';
import '../../core/services/mission_service.dart';
import '../missions/math_challenge_screen.dart';
import '../missions/typing_challenge_screen.dart';
import '../missions/shake_challenge_screen.dart';
import '../missions/walking_challenge_screen.dart';
import '../missions/tile_puzzle_screen.dart';
import '../missions/object_detection_mission_screen.dart';
import '../../core/services/ringtone_service.dart';

class AlarmRingingScreen extends ConsumerWidget {
  final AlarmEntity? alarm;

  const AlarmRingingScreen({super.key, this.alarm});

  void _startMission(BuildContext context, WidgetRef ref) {
    final missionType = alarm?.missionType ?? 'None';
    final scheduledTime = alarm?.alarmTime ?? DateTime.now();

    Widget missionScreen;
    switch (missionType) {
      case 'Math':
        missionScreen = MathChallengeScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      case 'Typing':
        missionScreen = TypingChallengeScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      case 'Shake':
        missionScreen = ShakeChallengeScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      case 'Walking':
        ref.read(walkingStepsProvider.notifier).state = 0;
        ref.read(walkingInitialStepsProvider.notifier).state = null;
        ref.read(walkingPermissionDeniedProvider.notifier).state = false;
        ref.read(walkingSensorUnavailableProvider.notifier).state = false;
        ref.read(walkingStartTimeProvider.notifier).state = DateTime.now();
        missionScreen = WalkingChallengeScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      case 'Tile Puzzle':
        missionScreen = TilePuzzleScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      case 'Object Detection':
        missionScreen = ObjectDetectionMissionScreen(scheduledTime: scheduledTime, alarm: alarm);
        break;
      default:
        Navigator.pop(context);
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => missionScreen),
    );
  }

  void _snoozeAlarm(BuildContext context, WidgetRef ref) async {
    if (alarm == null) return;
    
    // Stop the ringtone
    await RingtoneService.stop();
    
    // Stop the current ringing alarm
    await Alarm.stop(alarm!.id);

    // Schedule a temporary snooze alarm in 5 minutes
    final snoozeTime = DateTime.now().add(const Duration(minutes: 5));
    final snoozeAlarm = AlarmEntity(
      label: 'Snooze: ${alarm!.label}',
      alarmTime: snoozeTime,
      enabled: true,
      repeatDays: const [],
      ringtone: alarm!.ringtone,
      missionType: alarm!.missionType,
      followUpEnabled: false,
      createdAt: DateTime.now(),
      mathDifficulty: alarm!.mathDifficulty,
      puzzleDifficulty: alarm!.puzzleDifficulty,
      puzzleSize: alarm!.puzzleSize,
      shakeLimit: alarm!.shakeLimit,
      stepGoal: alarm!.stepGoal,
      walkingDifficulty: alarm!.walkingDifficulty,
      targetObject: alarm!.targetObject,
    );

    // Save and schedule the snooze alarm
    await ref.read(alarmRepositoryProvider).saveAlarm(snoozeAlarm);
    await ref.read(alarmSchedulerServiceProvider).scheduleAlarm(snoozeAlarm);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alarm snoozed for 5 minutes')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
    final isNight = _isNightMode(themeMode, now.hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    
    final timeStr = DateFormat('hh:mm a').format(now);
    final missionType = alarm?.missionType ?? 'None';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SkyBackground(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Text(
                  'GOOD MORNING',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        letterSpacing: 8,
                        fontWeight: FontWeight.w900,
                        color: textColor.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: -2,
                      ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      if (missionType != 'None') ...[
                        PremiumCard(
                          isGlass: isNight,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'Mission Active',
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                missionType,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _startMission(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 64),
                            elevation: 12,
                            shadowColor: primaryColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text(
                            'START MISSION',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => _snoozeAlarm(context, ref),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            side: BorderSide(color: textColor.withOpacity(0.3), width: 2),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text(
                            'SNOOZE (5 Min)',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5),
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () async {
                            await RingtoneService.stop();
                            if (alarm != null) {
                              await ref.read(missionServiceProvider).completeMission(
                                    missionType: 'None',
                                    scheduledTime: alarm!.alarmTime,
                                    alarm: alarm,
                                  );
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 64),
                            elevation: 12,
                            shadowColor: primaryColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text(
                            'DISMISS',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}
