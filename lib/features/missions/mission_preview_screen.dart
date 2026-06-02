import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import '../../models/mission_model.dart';
import 'math_challenge_screen.dart';
import 'typing_challenge_screen.dart';
import 'shake_challenge_screen.dart';
import 'walking_challenge_screen.dart';
import 'tile_puzzle_screen.dart';
import 'object_detection_mission_screen.dart';

class MissionPreviewScreen extends StatefulWidget {
  final int initialIndex;
  const MissionPreviewScreen({super.key, this.initialIndex = 0});

  @override
  State<MissionPreviewScreen> createState() => _MissionPreviewScreenState();
}

class _MissionPreviewScreenState extends State<MissionPreviewScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final missions = MissionRegistry.missions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Focus'),
        backgroundColor: Colors.transparent,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return _buildMissionPreview(context, mission);
        },
      ),
    );
  }

  Widget _buildMissionPreview(BuildContext context, MissionMetadata mission) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: HelioColors.sunriseOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(mission.icon, size: 80, color: HelioColors.sunriseOrange),
          ),
          const SizedBox(height: 24),
          Text(mission.name, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          _buildDifficultyStars(mission.difficulty),
          const SizedBox(height: 24),
          Text(
            mission.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: HelioColors.textSecondary),
          ),
          const SizedBox(height: 48),
          _buildSectionTitle('SAMPLE INTERACTION'),
          const SizedBox(height: 16),
          _buildSampleInteraction(mission),
          const SizedBox(height: 48),
          _buildSectionTitle('MORNING BENEFITS'),
          const SizedBox(height: 16),
          _buildBenefitsList(mission.benefits),
          const SizedBox(height: 60),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _launchMission(context, mission.name),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HelioColors.morningYellow,
                    side: const BorderSide(color: HelioColors.morningYellow),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('TRY NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, mission.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HelioColors.sunriseOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('USE THIS MISSION', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Text(
        title,
        style: const TextStyle(letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold, color: HelioColors.morningYellow),
      ),
    );
  }

  Widget _buildDifficultyStars(int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 20,
          color: index < level ? HelioColors.morningYellow : Colors.white10,
        );
      }),
    );
  }

  Widget _buildSampleInteraction(MissionMetadata mission) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HelioColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          if (mission.name == 'Math') ...[
            Text('Question', style: TextStyle(color: HelioColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
            Text(mission.sampleText, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Solve to wake up', style: TextStyle(color: HelioColors.morningYellow, fontSize: 12)),
          ] else if (mission.name == 'Typing') ...[
            const Icon(Icons.format_quote, color: HelioColors.sunriseOrange),
            Text(
              mission.sampleText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(value: 0.3, color: HelioColors.sunriseOrange, backgroundColor: Colors.white10),
          ] else if (mission.name == 'Shake') ...[
            const Icon(Icons.vibration, size: 48, color: HelioColors.sunriseOrange),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: const TextStyle(fontWeight: FontWeight.bold)),
          ] else if (mission.name == 'Walking') ...[
            const Icon(Icons.directions_walk, size: 48, color: HelioColors.sunriseOrange),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: const TextStyle(fontWeight: FontWeight.bold)),
          ] else if (mission.name == 'Tile Puzzle') ...[
            Text(mission.sampleText, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'monospace', fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Rearrange correctly', style: TextStyle(color: HelioColors.morningYellow, fontSize: 12)),
          ] else if (mission.name == 'Object Detection') ...[
            const Icon(Icons.camera_alt, size: 48, color: HelioColors.sunriseOrange),
            const SizedBox(height: 16),
            Text(mission.sampleText, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('[ Scan Area ]', style: TextStyle(color: HelioColors.morningYellow, fontSize: 10)),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefitsList(List<String> benefits) {
    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
              const SizedBox(width: 12),
              Text(benefit, style: const TextStyle(color: HelioColors.textPrimary)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
