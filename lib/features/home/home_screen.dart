import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/alarm_provider.dart';
import '../missions/mission_preview_screen.dart';
import '../mood/mood_tracking_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final now = DateTime.now();
    final isNight = _isNightMode(themeMode, now.hour);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, isNight ? 280 : 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, now, isNight),
                const SizedBox(height: 32),
                _buildActionButtons(context, isNight),
                const SizedBox(height: 24),
                _buildDailyStreakCard(context, isNight),
                _buildTodaysGoalCard(context, isNight),
                _buildMoodCard(context, isNight),
                _buildNextAlarmSection(context, ref, isNight),
                const SizedBox(height: 80), // Space for floating nav bar
              ],
            ),
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

  Widget _buildHeader(BuildContext context, DateTime now, bool isNight) {
    final greeting = _getGreeting(now.hour);
    final timeStr = _formatTime(now);
    final dateStr = _formatDate(now);
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isNight ? "Wind down and reflect" : "Let's make today productive",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              Text(
                timeStr,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 64,
                  letterSpacing: -2,
                ),
              ),
              Text(
                dateStr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isNight) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Log Mood',
            icon: Icons.sentiment_satisfied_alt_rounded,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
            ),
            isNight: isNight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            label: 'Test Missions',
            icon: Icons.track_changes_rounded,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MissionPreviewScreen()),
            ),
            isNight: isNight,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyStreakCard(BuildContext context, bool isNight) {
    return PremiumCard(
      isGlass: isNight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Streak',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isNight ? Colors.white : HelioColors.dayText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '12 Days',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep it up!',
                  style: TextStyle(
                    fontSize: 14,
                    color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          _StreakProgressRing(isNight: isNight),
        ],
      ),
    );
  }

  Widget _buildTodaysGoalCard(BuildContext context, bool isNight) {
    return PremiumCard(
      isGlass: isNight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Today\'s Goal',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isNight ? Colors.white : HelioColors.dayText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Complete 3 missions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: isNight ? Colors.white : HelioColors.dayText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.66,
                    minHeight: 8,
                    backgroundColor: (isNight ? Colors.white : HelioColors.dayPrimary).withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '2 / 3',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, bool isNight) {
    return PremiumCard(
      isGlass: isNight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '😊',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Today',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isNight ? Colors.white : HelioColors.dayText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isNight ? 'Calm' : 'Good',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isNight ? 'Great job today!' : 'You\'re doing great!',
                  style: TextStyle(
                    fontSize: 14,
                    color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (isNight ? HelioColors.nightPrimary : Colors.green).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isNight ? Icons.sentiment_satisfied_rounded : Icons.sentiment_very_satisfied_rounded,
                color: isNight ? HelioColors.nightPrimary : Colors.green,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAlarmSection(BuildContext context, WidgetRef ref, bool isNight) {
    final alarmsAsync = ref.watch(alarmNotifierProvider);
    return alarmsAsync.when(
      data: (alarms) {
        final activeAlarms = alarms.where((a) => a.isEnabled).toList();
        if (activeAlarms.isEmpty) return const SizedBox.shrink();
        final alarm = activeAlarms.first;
        final timeStr = "${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}";

        return PremiumCard(
          isGlass: isNight,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isNight ? HelioColors.nightPrimary : Colors.orange).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: isNight ? HelioColors.nightPrimary : Colors.orange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Alarm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isNight ? Colors.white : HelioColors.dayText,
                      ),
                    ),
                    Text(
                      'Evening Focus',
                      style: TextStyle(
                        fontSize: 14,
                        color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isNight ? HelioColors.nightPrimary : Colors.green).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isNight ? HelioColors.nightPrimary : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _getGreeting(int hour) {
    if (hour >= 5 && hour < 12) return 'Good Morning, Suhani! ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon, Suhani! 🌤️';
    return 'Good Evening, Suhani! 🌙';
  }

  String _formatTime(DateTime now) {
    int hour = now.hour % 12;
    if (hour == 0) hour = 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  String _formatDate(DateTime now) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isNight;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isNight ? Colors.white.withOpacity(0.1) : Colors.white,
        foregroundColor: isNight ? Colors.white : HelioColors.dayText,
        elevation: isNight ? 0 : 4,
        shadowColor: HelioColors.dayShadow,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: isNight ? BorderSide(color: Colors.white.withOpacity(0.1)) : null,
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (isNight) return Colors.white.withOpacity(0.1);
          return Colors.white;
        }),
      ),
    );
  }
}

class _StreakProgressRing extends StatelessWidget {
  final bool isNight;
  const _StreakProgressRing({required this.isNight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 8,
            backgroundColor: (isNight ? Colors.white : HelioColors.dayPrimary).withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
            ),
          ),
        ),
        Icon(
          Icons.local_fire_department_rounded,
          color: Colors.orange,
          size: 32,
        ),
      ],
    );
  }
}
