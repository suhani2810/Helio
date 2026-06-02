import 'package:flutter/material.dart';

class MissionMetadata {
  final String name;
  final IconData icon;
  final String description;
  final int difficulty; // 1-3
  final List<String> benefits;
  final String sampleText;
  final Widget? sampleInteraction;

  const MissionMetadata({
    required this.name,
    required this.icon,
    required this.description,
    required this.difficulty,
    required this.benefits,
    this.sampleText = '',
    this.sampleInteraction,
  });
}

class MissionRegistry {
  static List<MissionMetadata> missions = [
    const MissionMetadata(
      name: 'Math',
      icon: Icons.calculate,
      description: 'Solve a math problem to wake up your cognitive functions.',
      difficulty: 2,
      benefits: ['Sharpens focus', 'Activates logic', 'Immediate alertness'],
      sampleText: '24 + 17 = ?',
    ),
    const MissionMetadata(
      name: 'Typing',
      icon: Icons.keyboard,
      description: 'Type a motivational quote to start your day with purpose.',
      difficulty: 2,
      benefits: ['Improves motor skills', 'Positive mindset', 'Hand-eye coordination'],
      sampleText: '"The sun is rising and so am I."',
    ),
    const MissionMetadata(
      name: 'Shake',
      icon: Icons.vibration,
      description: 'Shake your phone vigorously to stimulate circulation.',
      difficulty: 1,
      benefits: ['Increases blood flow', 'Physical activation', 'Releases tension'],
      sampleText: 'Shake progress: 0/10',
    ),
    const MissionMetadata(
      name: 'Walking',
      icon: Icons.directions_walk,
      description: 'Walk a few steps to prove you are active and ready.',
      difficulty: 1,
      benefits: ['Boosts metabolism', 'Reduces morning grogginess', 'Postural reset'],
      sampleText: 'Steps: 0/30',
    ),
    const MissionMetadata(
      name: 'Tile Puzzle',
      icon: Icons.grid_view,
      description: 'Rearrange tiles to match the pattern and clear your mind.',
      difficulty: 3,
      benefits: ['Spatial reasoning', 'Dopamine release', 'Patience builder'],
      sampleText: '[ 1 ][ 2 ][ 3 ]\n[ 4 ][   ][ 5 ]\n[ 6 ][ 7 ][ 8 ]',
    ),
    const MissionMetadata(
      name: 'Object Detection',
      icon: Icons.camera_alt,
      description: 'Locate and photograph a specific household object.',
      difficulty: 3,
      benefits: ['Physical mobility', 'Visual recognition', 'Routine building'],
      sampleText: 'Looking for: Coffee Mug',
    ),
  ];
}
