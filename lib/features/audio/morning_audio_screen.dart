import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/repository_providers.dart';
import '../../models/morning_audio_entity.dart';

class MorningAudioScreen extends ConsumerStatefulWidget {
  const MorningAudioScreen({super.key});

  @override
  ConsumerState<MorningAudioScreen> createState() => _MorningAudioScreenState();
}

class _MorningAudioScreenState extends ConsumerState<MorningAudioScreen> {
  String? _selectedAudio;
  bool _isEnabled = true;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _audioList = [
    {'name': 'Forest Birds', 'icon': Icons.nature_people, 'path': 'assets/audio/morning_birds.mp3'},
    {'name': 'Soft Rain', 'icon': Icons.umbrella, 'path': 'assets/audio/rain.mp3'},
    {'name': 'Ocean Waves', 'icon': Icons.waves, 'path': 'assets/audio/waves.mp3'},
    {'name': 'Gentle Piano', 'icon': Icons.music_note, 'path': 'assets/audio/piano.mp3'},
    {'name': 'Morning Zen', 'icon': Icons.self_improvement, 'path': 'assets/audio/zen.mp3'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ref.read(morningAudioRepositoryProvider).getSettings();
    setState(() {
      _selectedAudio = settings.title;
      _isEnabled = settings.isEnabled;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final repo = ref.read(morningAudioRepositoryProvider);
    final audio = _audioList.firstWhere((a) => a['name'] == _selectedAudio);
    
    final settings = MorningAudioEntity(
      audioPath: audio['path'],
      isEnabled: _isEnabled,
      title: audio['name'],
    );
    
    await repo.updateSettings(settings);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                      'Morning Audio',
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PremiumCard(
                        isGlass: isNight,
                        child: Row(
                          children: [
                            Text(
                              'Enable Morning Audio',
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Switch(
                              value: _isEnabled,
                              onChanged: (val) => setState(() => _isEnabled = val),
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Sunrise Soundscape',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
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
                          return _buildAudioTile(audio, isSelected, isNight, textColor, primaryColor);
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: primaryColor.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Save Selection',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildAudioTile(Map<String, dynamic> audio, bool isSelected, bool isNight, Color textColor, Color primaryColor) {
    return GestureDetector(
      onTap: () => setState(() => _selectedAudio = audio['name'] as String),
      child: PremiumCard(
        isGlass: isNight,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isSelected ? primaryColor : textColor).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                audio['icon'] as IconData,
                color: isSelected ? primaryColor : textColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              audio['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 16,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
