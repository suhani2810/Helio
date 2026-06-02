import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import '../missions/math_challenge_screen.dart';
import '../missions/typing_challenge_screen.dart';
import '../missions/shake_challenge_screen.dart';
import '../missions/walking_challenge_screen.dart';
import '../missions/tile_puzzle_screen.dart';
import '../missions/object_detection_setup_screen.dart'; // Using setup as placeholder for mission

class AlarmRingingScreen extends StatelessWidget {
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
        missionScreen = const ObjectDetectionSetupScreen(); // Placeholder
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              HelioColors.sunriseOrange,
              HelioColors.softPink,
              HelioColors.dawnPurple,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                'GOOD MORNING',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                '07:00 AM',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      color: Colors.white,
                    ),
              ),
              const Spacer(),
              if (missionType != 'None') ...[
                Text(
                  'Mission: $missionType',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () => _startMission(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: HelioColors.sunriseOrange,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('START MISSION', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: HelioColors.sunriseOrange,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('DISMISS', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
