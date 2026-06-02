import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import '../../models/mission_model.dart';
import 'mission_preview_screen.dart';

class MissionSelectionScreen extends StatelessWidget {
  const MissionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final missions = MissionRegistry.missions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Mission'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HelioColors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: HelioColors.sunriseOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(mission.icon, color: HelioColors.sunriseOrange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              mission.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: HelioColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildDifficulty(mission.difficulty),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MissionPreviewScreen(initialIndex: index),
                            ),
                          );
                        },
                        child: const Text('Preview', style: TextStyle(color: HelioColors.morningYellow)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, mission.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HelioColors.sunriseOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDifficulty(int level) {
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 16,
          color: index < level ? HelioColors.morningYellow : Colors.white10,
        );
      }),
    );
  }
}
