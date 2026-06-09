import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';

class ShakeChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;

  const ShakeChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
  });

  @override
  ConsumerState<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends ConsumerState<ShakeChallengeScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  late AnimationController _shakeController;
  
  // Shake detection parameters
  static const double _shakeThreshold = 12.0;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _subscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      final double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      
      if (acceleration > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null || 
            now.difference(_lastShakeTime!) > const Duration(milliseconds: 80)) {
          _lastShakeTime = now;
          _onShake();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _onShake() {
    if (_progress >= 1.0) return;
    
    setState(() {
      _progress += 0.08;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _finish();
      }
    });
    
    _shakeController.forward(from: 0.0);
  }

  void _finish() async {
    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Shake',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.isPreview ? 'Preview Complete!' : 'Energy levels 100%! Ready to go!')),
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2),
                  ),
                  child: Icon(Icons.vibration_rounded, size: 64, color: primaryColor),
                ),
                const SizedBox(height: 40),
                Text(
                  'Shake to Wake!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Shake your phone to fill the energy bar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final sineValue = (1.0 - _shakeController.value) * 15 * 
                        (DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 1 : -1);
                    return Transform.translate(
                      offset: Offset(sineValue, 0),
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 240 + (_progress * 30),
                        width: 240 + (_progress * 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.1 + (_progress * 0.3)),
                              blurRadius: 40 + (_progress * 20),
                              spreadRadius: 5 + (_progress * 10),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 240,
                        width: 240,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 20,
                          strokeCap: StrokeCap.round,
                          backgroundColor: (isNight ? Colors.white : primaryColor).withValues(alpha: 0.05),
                          color: isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_progress * 100).toInt()}%',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              fontSize: 48,
                            ),
                          ),
                          Text(
                            'ENERGY',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor.withValues(alpha: 0.4),
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (widget.isPreview) ...[
                  TextButton.icon(
                    onPressed: _onShake,
                    icon: Icon(Icons.touch_app_rounded, color: textColor.withValues(alpha: 0.3)),
                    label: Text(
                      'SIMULATE SHAKE (PREVIEW)',
                      style: TextStyle(color: textColor.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel Preview',
                      style: TextStyle(color: textColor.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  const SizedBox(height: 60),
                ],
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
