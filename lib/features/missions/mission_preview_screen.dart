import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../models/mission_model.dart';
import 'math_challenge_screen.dart';
import 'typing_challenge_screen.dart';
import 'shake_challenge_screen.dart';
import 'walking_challenge_screen.dart';
import 'tile_puzzle_screen.dart';
import 'object_detection_mission_screen.dart';

class MissionPreviewScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const MissionPreviewScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MissionPreviewScreen> createState() => _MissionPreviewScreenState();
}

class _MissionPreviewScreenState extends ConsumerState<MissionPreviewScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final missions = MissionRegistry.missions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Mission Focus',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return _buildMissionPreview(context, mission, isNight, textColor);
                  },
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

  Widget _buildMissionPreview(BuildContext context, MissionMetadata mission, bool isNight, Color textColor) {
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final secondaryColor = isNight ? HelioColors.nightSecondary : HelioColors.daySecondary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor.withOpacity(0.2), width: 4),
            ),
            child: Icon(mission.icon, size: 72, color: primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            mission.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          _buildDifficultyStars(mission.difficulty, secondaryColor, textColor),
          const SizedBox(height: 24),
          Text(
            mission.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildSectionTitle('SAMPLE INTERACTION', secondaryColor),
          const SizedBox(height: 16),
          _buildSampleInteraction(mission, isNight, textColor, secondaryColor),
          const SizedBox(height: 40),
          _buildSectionTitle('MORNING BENEFITS', secondaryColor),
          const SizedBox(height: 16),
          _buildBenefitsList(mission.benefits, textColor),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _launchMission(context, mission.name),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('TRY NOW', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, mission.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('USE MISSION', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _launchMission(BuildContext context, String missionName) {
    Widget missionScreen;
    switch (missionName) {
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
        missionScreen = const ObjectDetectionMissionScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => missionScreen),
    );
  }

  Widget _buildSectionTitle(String title, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: accentColor.withOpacity(0.2), width: 2)),
      ),
      child: Text(
        title,
        style: TextStyle(
          letterSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: accentColor,
        ),
      ),
    );
  }

  Widget _buildDifficultyStars(int level, Color activeColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          Icons.star_rounded,
          size: 24,
          color: index < level ? activeColor : textColor.withOpacity(0.1),
        );
      }),
    );
  }

  Widget _buildSampleInteraction(MissionMetadata mission, bool isNight, Color textColor, Color accentColor) {
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          if (mission.name == 'Math') ...[
            Text('Question', style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(mission.sampleText, style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: textColor)),
            const SizedBox(height: 16),
            Text('Solve to wake up', style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.w700)),
          ] else if (mission.name == 'Typing') ...[
            Icon(Icons.format_quote_rounded, color: accentColor, size: 32),
            const SizedBox(height: 8),
            Text(
              mission.sampleText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: textColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.3,
                minHeight: 6,
                color: accentColor,
                backgroundColor: textColor.withOpacity(0.1),
              ),
            ),
          ] else if (mission.name == 'Shake') ...[
            Icon(Icons.vibration_rounded, size: 56, color: accentColor),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textColor)),
          ] else if (mission.name == 'Walking') ...[
            Icon(Icons.directions_walk_rounded, size: 56, color: accentColor),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textColor)),
          ] else if (mission.name == 'Tile Puzzle') ...[
            Text(
              mission.sampleText,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'monospace', fontSize: 20, color: textColor, fontWeight: FontWeight.bold, letterSpacing: 4),
            ),
            const SizedBox(height: 16),
            Text('Rearrange correctly', style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.w700)),
          ] else if (mission.name == 'Object Detection') ...[
            Icon(Icons.camera_alt_rounded, size: 56, color: accentColor),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textColor)),
            const SizedBox(height: 8),
            Text('[ Scan Area ]', style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefitsList(List<String> benefits, Color textColor) {
    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  benefit,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
