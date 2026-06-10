import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';
import '../mood/mood_tracking_screen.dart';

import '../../models/alarm_entity.dart';

class ShakeChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const ShakeChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends ConsumerState<ShakeChallengeScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  late AnimationController _shakeController;
  late final int _shakeLimit;
  
  // Shake detection parameters
  static const double _shakeThreshold = 12.0;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _shakeLimit = widget.alarm?.shakeLimit ?? 20;
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
      _progress += 1.0 / _shakeLimit;
      if (_progress >= 0.99) { // Handle float precision
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
        alarm: widget.alarm,
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

    // Calculate dynamic glow and progress colors based on shake completion
    final Color glowColor = Color.lerp(
      isNight ? const Color(0xFF6366F1) : const Color(0xFF3B82F6), // Indigo / Blue
      isNight ? const Color(0xFFF97316) : const Color(0xFFEF4444), // Orange / Red
      _progress,
    ) ?? primaryColor;

    final int remainingShakes = (_shakeLimit * (1.0 - _progress)).round().clamp(0, _shakeLimit);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // High-tech circular vibrating icon container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: glowColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: glowColor.withOpacity(0.2), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withOpacity(0.05),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.vibration_rounded,
                        size: 40,
                        color: glowColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title and subtitle
                    Text(
                      'Shake to Wake!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Physically shake your phone to fill the energy bar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),

                    // Shakes remaining pill badge
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _progress >= 1.0 ? 0.0 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: glowColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: glowColor.withOpacity(0.25), width: 1),
                        ),
                        child: Text(
                          '$remainingShakes SHAKES REMAINING',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: glowColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Reactor Core Section
                    AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        final sineValue = (1.0 - _shakeController.value) * 15 * 
                            (DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 1 : -1);
                        final scaleValue = 1.0 + (1.0 - _shakeController.value) * 0.12;
                        return Transform.scale(
                          scale: scaleValue,
                          child: Transform.translate(
                            offset: Offset(sineValue, 0),
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Dynamic background glow
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 220 + (_progress * 40),
                            width: 220 + (_progress * 40),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withOpacity(0.1 + (_progress * 0.35)),
                                  blurRadius: 40 + (_progress * 30),
                                  spreadRadius: 5 + (_progress * 15),
                                ),
                              ],
                            ),
                          ),
                          
                          // 2. Faint outer rotating orbit ring
                          SizedBox(
                            height: 260,
                            width: 260,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 1.0,
                              color: glowColor.withOpacity(0.15),
                            ),
                          ),
                          
                          // 3. Main Circular Progress Bar
                          SizedBox(
                            height: 230,
                            width: 230,
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 16,
                              strokeCap: StrokeCap.round,
                              backgroundColor: (isNight ? Colors.white : primaryColor).withOpacity(0.04),
                              color: glowColor,
                            ),
                          ),
                          
                          // 4. Glassmorphic Core
                          Container(
                            height: 185,
                            width: 185,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isNight ? Colors.black : Colors.white).withOpacity(isNight ? 0.25 : 0.45),
                              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(_progress * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          color: textColor,
                                          letterSpacing: -1,
                                          shadows: [
                                            Shadow(
                                              color: glowColor.withOpacity(0.35),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'ENERGY',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: textColor.withOpacity(0.45),
                                          letterSpacing: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Buttons and bottom controls
                    if (widget.isPreview) ...[
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _onShake,
                              icon: const Icon(Icons.touch_app_rounded, size: 18),
                              label: const Text(
                                'SIMULATE SHAKE',
                                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: glowColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel Preview',
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      // Brief motivating wake-up tip card for live alarm
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded, color: glowColor, size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Physical movement stimulates your nervous system to wake you up naturally.',
                                style: TextStyle(
                                  color: textColor.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
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
