import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class ShakeChallengeScreen extends ConsumerStatefulWidget {
  const ShakeChallengeScreen({super.key});

  @override
  ConsumerState<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends ConsumerState<ShakeChallengeScreen> {
  double _progress = 0.0;

  void _onShake() {
    setState(() {
      _progress += 0.05;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _finish();
      }
    });
  }

  void _finish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Energy levels 100%! Ready to go!')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
                ),
                child: Icon(Icons.vibration_rounded, size: 80, color: primaryColor),
              ),
              const SizedBox(height: 48),
              Text(
                'Shake to Wake!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the ring rapidly to simulate shaking',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: _onShake,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    Container(
                      height: 220,
                      width: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 16,
                        strokeCap: StrokeCap.round,
                        backgroundColor: (isNight ? Colors.white : primaryColor).withOpacity(0.1),
                        color: isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
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
}
