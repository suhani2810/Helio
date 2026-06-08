import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../mood/mood_tracking_screen.dart';

class ObjectDetectionMissionScreen extends ConsumerStatefulWidget {
  const ObjectDetectionMissionScreen({super.key});

  @override
  ConsumerState<ObjectDetectionMissionScreen> createState() => _ObjectDetectionMissionScreenState();
}

class _ObjectDetectionMissionScreenState extends ConsumerState<ObjectDetectionMissionScreen> {
  bool _isScanning = false;
  double _progress = 0.0;

  void _startScan() async {
    setState(() => _isScanning = true);
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _progress = i / 10);
    }
    _completeMission();
  }

  void _completeMission() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Object "Mug" Detected! Mission Complete.')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
      );
    });
  }

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
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor.withOpacity(0.1)),
                      ),
                      child: Icon(Icons.camera_enhance_rounded, size: 80, color: textColor.withOpacity(0.2)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Scanner Ready',
                      style: TextStyle(
                        color: textColor.withOpacity(0.4),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isScanning)
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 3),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(top: 280 * _progress),
                            height: 4,
                            width: 280,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 24,
                left: 24,
                right: 24,
                child: PremiumCard(
                  isGlass: isNight,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.search_rounded, color: primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Detecting: Coffee Mug',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 48,
                left: 48,
                right: 48,
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _startScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    elevation: 12,
                    shadowColor: primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(
                    _isScanning ? 'SCANNING...' : 'START DETECTION',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
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
}
