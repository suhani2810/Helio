import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../missions/math_challenge_screen.dart';
import '../missions/typing_challenge_screen.dart';
import '../missions/shake_challenge_screen.dart';
import '../missions/walking_challenge_screen.dart';
import '../missions/tile_puzzle_screen.dart';
import '../missions/object_detection_setup_screen.dart';

class AlarmRingingScreen extends ConsumerWidget {
  final String missionType;

  const AlarmRingingScreen({super.key, required this.missionType});

  void _startMission(BuildContext context) {
    Widget missionScreen;
    switch (missionType) {
      case 'Math':
        missionScreen = const MathChallengeScreen();
        break;
      case 'Typing':
        missionScreen = const TypingChallengeScreen();
        break;
      case 'Shake':
        missionScreen = const ShakeChallengeScreen();
        break;
      case 'Walking':
        missionScreen = const WalkingChallengeScreen();
        break;
      case 'Tile Puzzle':
        missionScreen = const TilePuzzleScreen();
        break;
      case 'Object Detection':
        missionScreen = const ObjectDetectionSetupScreen();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return Scaffold(
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
                '07:00 AM',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 88,
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
                        onPressed: () => _startMission(context),
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
                    ] else ...[
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
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
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}
