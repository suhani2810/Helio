import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class MorningAudioScreen extends ConsumerStatefulWidget {
  const MorningAudioScreen({super.key});

  @override
  ConsumerState<MorningAudioScreen> createState() => _MorningAudioScreenState();
}

class _MorningAudioScreenState extends ConsumerState<MorningAudioScreen> {
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
                      Text(
                        'Audio Settings',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildVolumeSlider(isNight, textColor, primaryColor),
                      _buildFadeSwitch(isNight, textColor, primaryColor),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: primaryColor.withOpacity(0.4),
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
        child: Container(
          decoration: isSelected && !isNight
              ? BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                )
              : null,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isSelected ? primaryColor : textColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  audio['icon'] as IconData,
                  color: isSelected ? primaryColor : textColor.withOpacity(0.5),
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
      ),
    );
  }

  Widget _buildVolumeSlider(bool isNight, Color textColor, Color primaryColor) {
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Volume',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              Text(
                '${(_volume * 100).toInt()}%',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),
              )
            ],
          ),
          Slider(
            value: _volume,
            onChanged: (val) => setState(() => _volume = val),
            activeColor: primaryColor,
            inactiveColor: primaryColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildFadeSwitch(bool isNight, Color textColor, Color primaryColor) {
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          'Gradient Fade-in',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Slowly increase volume over sunrise',
          style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
        ),
        trailing: Switch(
          value: _fadeEnabled,
          onChanged: (val) => setState(() => _fadeEnabled = val),
          activeColor: primaryColor,
        ),
      ),
    );
  }
}
