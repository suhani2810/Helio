import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../models/mission_model.dart';
import 'mission_preview_screen.dart';

class MissionSelectionScreen extends ConsumerWidget {
  const MissionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    
    final missions = MissionRegistry.missions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (isNight) const SizedBox(height: 240),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Choose Mission',
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(mission.icon, color: primaryColor, size: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mission.name,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        mission.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.6),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _buildDifficulty(mission.difficulty, isNight, textColor),
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
                                  child: Text(
                                    'Preview',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, mission.name),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text(
                                    'Select',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
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

  Widget _buildDifficulty(int level, bool isNight, Color textColor) {
    final activeColor = isNight ? HelioColors.nightSecondary : HelioColors.daySecondary;
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          Icons.star_rounded,
          size: 18,
          color: index < level ? activeColor : textColor.withOpacity(0.1),
        );
      }),
    );
  }
}
