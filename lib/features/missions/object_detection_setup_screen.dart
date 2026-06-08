import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class ObjectDetectionSetupScreen extends ConsumerWidget {
  const ObjectDetectionSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    final objects = [
      {'name': 'Toothbrush', 'icon': Icons.cleaning_services},
      {'name': 'Mug', 'icon': Icons.coffee},
      {'name': 'Spoon', 'icon': Icons.restaurant},
      {'name': 'Water Bottle', 'icon': Icons.water_drop},
      {'name': 'Pillow', 'icon': Icons.bed},
      {'name': 'Book', 'icon': Icons.book},
      {'name': 'Toothpaste', 'icon': Icons.brush},
    ];

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
                      'Object Setup',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: PremiumCard(
                  isGlass: isNight,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextField(
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded, color: textColor.withOpacity(0.5)),
                      hintText: 'Search objects...',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: PremiumCard(
                    isGlass: isNight,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.remove_red_eye_rounded, size: 64, color: primaryColor.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            'Camera Preview',
                            style: TextStyle(
                              color: textColor.withOpacity(0.3),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  decoration: BoxDecoration(
                    color: isNight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Target Object',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: objects.length,
                          itemBuilder: (context, index) {
                            return _buildObjectCard(context, objects[index], isNight, textColor, primaryColor);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: primaryColor.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'Continue to Setup',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5),
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

  Widget _buildObjectCard(BuildContext context, Map<String, dynamic> object, bool isNight, Color textColor, Color primaryColor) {
    return GestureDetector(
      onTap: () {}, // Handle selection
      child: PremiumCard(
        isGlass: isNight,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(object['icon'] as IconData, color: primaryColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              object['name'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
