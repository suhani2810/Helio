import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';
import '../mood/mood_tracking_screen.dart';
import '../../models/alarm_entity.dart';
import 'shake_challenge_screen.dart';

// Riverpod State Providers to persist mission state across screen rotations
final walkingStepsProvider = StateProvider<int>((ref) => 0);
final walkingInitialStepsProvider = StateProvider<int?>((ref) => null);
final walkingPermissionDeniedProvider = StateProvider<bool>((ref) => false);
final walkingSensorUnavailableProvider = StateProvider<bool>((ref) => false);
final walkingStartTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

class WalkingChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const WalkingChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<WalkingChallengeScreen> createState() => _WalkingChallengeScreenState();
}

class _WalkingChallengeScreenState extends ConsumerState<WalkingChallengeScreen> {
  late final int _targetSteps;
  StreamSubscription<StepCount>? _stepCountSubscription;

  @override
  void initState() {
    super.initState();
    _targetSteps = widget.alarm?.stepGoal ?? 100;
    _startStepTracking();
  }

  Future<void> _startStepTracking() async {
    // Check if permission or sensor is already marked unavailable
    if (ref.read(walkingPermissionDeniedProvider) || ref.read(walkingSensorUnavailableProvider)) {
      return;
    }

    final status = await Permission.activityRecognition.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        ref.read(walkingPermissionDeniedProvider.notifier).state = true;
      }
      return;
    }

    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );
    } catch (e) {
      if (mounted) {
        ref.read(walkingSensorUnavailableProvider.notifier).state = true;
      }
    }
  }

  void _onStepCount(StepCount event) {
    if (!mounted) return;
    
    final initial = ref.read(walkingInitialStepsProvider);
    if (initial == null) {
      ref.read(walkingInitialStepsProvider.notifier).state = event.steps;
    } else {
      final currentSteps = (event.steps - initial).clamp(0, _targetSteps);
      ref.read(walkingStepsProvider.notifier).state = currentSteps;
      if (currentSteps >= _targetSteps) {
        _finish();
      }
    }
  }

  void _onStepCountError(dynamic error) {
    if (mounted) {
      ref.read(walkingSensorUnavailableProvider.notifier).state = true;
    }
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    super.dispose();
  }

  void _finish() async {
    final startTime = ref.read(walkingStartTimeProvider);
    final steps = ref.read(walkingStepsProvider);
    final duration = DateTime.now().difference(startTime).inSeconds;

    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Walking',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
        alarm: widget.alarm,
        walkingStepsGoal: _targetSteps,
        walkingStepsTaken: steps,
        walkingCompletionTime: duration,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.isPreview ? 'Preview Complete!' : 'Target reached! You are now fully awake.')),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (widget.isPreview) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
            (route) => route.isFirst,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final secondaryColor = isNight ? HelioColors.nightSecondary : HelioColors.daySecondary;

    final steps = ref.watch(walkingStepsProvider);
    final permissionDenied = ref.watch(walkingPermissionDeniedProvider);
    final sensorUnavailable = ref.watch(walkingSensorUnavailableProvider);
    final isFallback = permissionDenied || sensorUnavailable;

    double progress = _targetSteps > 0 ? (steps / _targetSteps) : 0.0;
    int remaining = (_targetSteps - steps).clamp(0, _targetSteps);

    final walkingDiff = widget.alarm?.walkingDifficulty ?? 1;
    final diffLabel = ['Easy', 'Medium', 'Hard'][walkingDiff];
    final diffColor = [HelioColors.success, primaryColor, HelioColors.warning][walkingDiff];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Step Mission',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  isFallback
                      ? 'Sensor issues detected.'
                      : 'Physical movement increases heart rate and cortisol levels, helping you wake up naturally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              if (isFallback)
                _buildFallbackUI(textColor, primaryColor, permissionDenied)
              else
                _buildStepCounter(progress, steps, textColor, primaryColor, secondaryColor, diffLabel, diffColor),
              const Spacer(),
              if (!isFallback) ...[
                PremiumCard(
                  isGlass: isNight,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        'Remaining:',
                        style: TextStyle(fontWeight: FontWeight.w600, color: textColor.withOpacity(0.5), fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$remaining steps',
                        style: TextStyle(fontWeight: FontWeight.w800, color: secondaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    steps < (_targetSteps / 3) 
                        ? 'Keep moving!' 
                        : steps < (_targetSteps * 2 / 3) 
                            ? 'Almost there!' 
                            : 'Just a few more steps...',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
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

  Widget _buildStepCounter(double progress, int steps, Color textColor, Color primaryColor, Color secondaryColor, String diffLabel, Color diffColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current Difficulty Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: diffColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: diffColor.withOpacity(0.3), width: 1.5),
          ),
          child: Text(
            'DIFFICULTY: ${diffLabel.toUpperCase()}',
            style: TextStyle(
              color: diffColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Live Steps Progress Text
        Text(
          'Steps Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$steps / $_targetSteps',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 24),
        // Progress Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: secondaryColor,
              backgroundColor: textColor.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackUI(Color textColor, Color primaryColor, bool permissionDenied) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: HelioColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HelioColors.error.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: HelioColors.error),
          const SizedBox(height: 16),
          Text(
            permissionDenied
                ? 'Activity Recognition Permission Denied'
                : 'Step Counter sensor not available on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            permissionDenied
                ? 'Activity recognition permission was denied. Please enable it in system settings or use the fallback Shake mission.'
                : 'This device does not support hardware step counting. Please use the fallback Shake mission to complete your wakeup.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShakeChallengeScreen(
                    isPreview: widget.isPreview,
                    scheduledTime: widget.scheduledTime,
                    alarm: widget.alarm,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'FALLBACK: SHAKE MISSION',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
