import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../core/theme/theme_provider.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../widgets/theme/theme_preview_card.dart';

class ThemePreviewScreen extends ConsumerWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    final notifier = ref.read(themeControllerProvider.notifier);
    final isNight = _isNightMode(mode, DateTime.now().hour);
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
                      'Appearance',
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
                        'Theme Mode',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildModeChip(ref, mode, AppThemeMode.auto, 'Auto', isNight, primaryColor, textColor),
                            _buildModeChip(ref, mode, AppThemeMode.day, 'Day', isNight, primaryColor, textColor),
                            _buildModeChip(ref, mode, AppThemeMode.night, 'Night', isNight, primaryColor, textColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Live Previews',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ThemePreviewCard(
                              label: 'System Auto',
                              isNight: false,
                              onTap: () => notifier.setMode(AppThemeMode.auto),
                            ),
                            const SizedBox(width: 16),
                            ThemePreviewCard(
                              label: 'Bright Day',
                              isNight: false,
                              onTap: () => notifier.setMode(AppThemeMode.day),
                            ),
                            const SizedBox(width: 16),
                            ThemePreviewCard(
                              label: 'Starry Night',
                              isNight: true,
                              onTap: () => notifier.setMode(AppThemeMode.night),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
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
                            'Save Settings',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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

  Widget _buildModeChip(
    WidgetRef ref,
    AppThemeMode currentMode,
    AppThemeMode targetMode,
    String label,
    bool isNight,
    Color primaryColor,
    Color textColor,
  ) {
    final isSelected = currentMode == targetMode;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => ref.read(themeControllerProvider.notifier).setMode(targetMode),
      backgroundColor: Colors.transparent,
      selectedColor: primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? primaryColor : textColor.withOpacity(0.6),
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.transparent,
        ),
      ),
      showCheckmark: false,
    );
  }
}
