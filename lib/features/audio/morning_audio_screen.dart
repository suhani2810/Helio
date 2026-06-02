import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class MorningAudioScreen extends StatefulWidget {
  const MorningAudioScreen({super.key});

  @override
  State<MorningAudioScreen> createState() => _MorningAudioScreenState();
}

class _MorningAudioScreenState extends State<MorningAudioScreen> {
  String? _selectedAudio = 'Forest Birds';
  double _volume = 0.5;
  bool _fadeEnabled = true;

  final List<Map<String, dynamic>> _audioList = [
    {'name': 'Forest Birds', 'icon': Icons.nature_people},
    {'name': 'Soft Rain', 'icon': Icons.umbrella},
    {'name': 'Ocean Waves', 'icon': Icons.waves},
    {'name': 'Gentle Piano', 'icon': Icons.music_note},
    {'name': 'Morning Zen', 'icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morning Audio'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sunrise Soundscape',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _audioList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final audio = _audioList[index];
                final isSelected = _selectedAudio == audio['name'];
                return _buildAudioTile(audio, isSelected);
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Audio Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildVolumeSlider(),
            _buildFadeSwitch(),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HelioColors.sunriseOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save Selection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioTile(Map<String, dynamic> audio, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedAudio = audio['name'] as String),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? HelioColors.sunriseOrange.withOpacity(0.1)
              : HelioColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? HelioColors.sunriseOrange
                : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(
              audio['icon'] as IconData,
              color: isSelected
                  ? HelioColors.sunriseOrange
                  : HelioColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Text(
              audio['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? HelioColors.textPrimary
                    : HelioColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: HelioColors.sunriseOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Volume'), Text('${(_volume * 100).toInt()}%')],
        ),
        Slider(
          value: _volume,
          onChanged: (val) => setState(() => _volume = val),
          activeColor: HelioColors.sunriseOrange,
        ),
      ],
    );
  }

  Widget _buildFadeSwitch() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Gradient Fade-in'),
      subtitle: const Text('Slowly increase volume over sunrise'),
      trailing: Switch(
        value: _fadeEnabled,
        onChanged: (val) => setState(() => _fadeEnabled = val),
        activeThumbColor: HelioColors.sunriseOrange,
      ),
    );
  }
}
