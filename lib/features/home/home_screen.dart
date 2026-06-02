import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../providers/alarm_provider.dart';
import '../alarms/alarm_ringing_screen.dart';
import '../missions/mission_preview_screen.dart';
import '../mood/mood_tracking_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmNotifierProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HelioColors.backgroundDark,
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildSunriseVisual(),
              const SizedBox(height: 40),
              Text(
                '12:45 PM', // Mock time for UI
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Text(
                'Tuesday, June 2',
                style: TextStyle(color: HelioColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQuickAction(
                    context,
                    Icons.mood,
                    'Log Mood',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodTrackingScreen())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.play_circle_outline,
                    'Test Missions',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MissionPreviewScreen())),
                  ),
                ],
              ),
              const Spacer(),
              alarmsAsync.when(
                data: (alarms) {
                  final nextAlarm = alarms.where((a) => a.isEnabled).toList();
                  if (nextAlarm.isEmpty) return _buildNoAlarmCard(context);
                  return _buildNextAlarmCard(context, nextAlarm.first);
                },
                loading: () => const CircularProgressIndicator(color: HelioColors.sunriseOrange),
                error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 16),
              alarmsAsync.when(
                data: (alarms) {
                  final nextAlarm = alarms.where((a) => a.isEnabled).toList();
                  if (nextAlarm.isEmpty) return const SizedBox.shrink();
                  return _buildTestTrigger(context, nextAlarm.first.missionType);
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: HelioColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: HelioColors.morningYellow, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTestTrigger(BuildContext context, String missionType) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlarmRingingScreen(missionType: missionType),
          ),
        );
      },
      icon: const Icon(Icons.flash_on, size: 16),
      label: const Text('DEBUG: TRIGGER ALARM'),
      style: TextButton.styleFrom(
        foregroundColor: HelioColors.sunriseOrange.withOpacity(0.5),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSunriseVisual() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: HelioColors.sunriseOrange.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
        gradient: const RadialGradient(
          colors: [
            HelioColors.morningYellow,
            HelioColors.sunriseOrange,
            Colors.transparent,
          ],
          stops: [0.3, 0.6, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: HelioColors.morningYellow,
          ),
        ),
      ),
    );
  }

  Widget _buildNoAlarmCard(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.alarm_off, color: HelioColors.textSecondary, size: 32),
        SizedBox(height: 8),
        Text('No Active Alarms', style: TextStyle(color: HelioColors.textSecondary)),
      ],
    );
  }

  Widget _buildNextAlarmCard(BuildContext context, dynamic alarm) {
    final timeStr = '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: HelioColors.cardDark,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HelioColors.sunriseOrange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active,
                color: HelioColors.sunriseOrange,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Alarm',
                  style: TextStyle(color: HelioColors.textSecondary, fontSize: 12),
                ),
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'Active',
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HelioColors.sunriseOrange,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
