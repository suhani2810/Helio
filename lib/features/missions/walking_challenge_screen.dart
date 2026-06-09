import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';

class WalkingChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;

  const WalkingChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
  });

  @override
  ConsumerState<WalkingChallengeScreen> createState() => _WalkingChallengeScreenState();
}

class _WalkingChallengeScreenState extends ConsumerState<WalkingChallengeScreen> {
  int _steps = 0;
  final int _targetSteps = 30;

  void _onStep() {
    setState(() {
      _steps++;
      if (_steps >= _targetSteps) {
        _finish();
      }
    });
  }

  void _finish() async {
    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Walking',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
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
          Navigator.of(context).popUntil((route) => route.isFirst);
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
    double progress = _steps / _targetSteps;

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
                  'Physical movement increases heart rate and cortisol levels, helping you wake up naturally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              _buildStepCounter(progress, textColor, primaryColor, secondaryColor),
              const SizedBox(height: 32),
              PremiumCard(
                isGlass: isNight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  '${_targetSteps - _steps} steps remaining',
                  style: TextStyle(fontWeight: FontWeight.w800, color: secondaryColor, fontSize: 16),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _steps < 10 
                      ? 'Keep moving!' 
                      : _steps < 20 
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
              const SizedBox(height: 40),
              // DEBUG BUTTON
              TextButton.icon(
                onPressed: _onStep,
                icon: Icon(Icons.touch_app_rounded, color: textColor.withValues(alpha: 0.3)),
                label: Text(
                  'SIMULATE STEP',
                  style: TextStyle(color: textColor.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
                ),
              ),
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

  Widget _buildStepCounter(double progress, Color textColor, Color primaryColor, Color secondaryColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          height: 260,
          width: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          width: 260,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 20,
            strokeCap: StrokeCap.round,
            backgroundColor: textColor.withValues(alpha: 0.05),
            color: secondaryColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk_rounded, size: 64, color: primaryColor),
            Text(
              '$_steps',
              style: TextStyle(
                fontSize: 88,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -2,
              ),
            ),
            Text(
              'OF $_targetSteps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor.withValues(alpha: 0.4),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
