import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/alarm_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/time_provider.dart';
import '../missions/mission_preview_screen.dart';
import '../mood/mood_tracking_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
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
                _buildDailyStreakCard(context, ref, isNight),
                _buildTodaysGoalCard(context, ref, isNight),
                _buildMoodCard(context, ref, isNight),
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
    final timeStr = DateFormat('hh:mm a').format(now);
    final dateStr = DateFormat('EEEE, MMM d').format(now);
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
                color: textColor.withValues(alpha: 0.7),
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
                  color: textColor.withValues(alpha: 0.7),
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

  Widget _buildDailyStreakCard(BuildContext context, WidgetRef ref, bool isNight) {
    final streakAsync = ref.watch(streakNotifierProvider);
    final streak = streakAsync.value ?? 0;

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
                    const Icon(
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
                  '$streak Days',
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
                    color: (isNight ? Colors.white : HelioColors.dayText).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          _StreakProgressRing(isNight: isNight, streak: streak),
        ],
      ),
    );
  }

  Widget _buildTodaysGoalCard(BuildContext context, WidgetRef ref, bool isNight) {
    // Task 4: Real goal tracking
    final wakeupCountAsync = ref.watch(totalWakeupsProvider);
    final count = wakeupCountAsync.value ?? 0;
    
    return PremiumCard(
      isGlass: isNight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Activity Goal',
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
            'Total Wakeups: $count',
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
                    value: (count % 10) / 10.0,
                    minHeight: 8,
                    backgroundColor: (isNight ? Colors.white : HelioColors.dayPrimary).withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${count % 10} / 10',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: (isNight ? Colors.white : HelioColors.dayText).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, WidgetRef ref, bool isNight) {
    final moodAsync = ref.watch(moodNotifierProvider);
    final moodEntry = moodAsync.value;
    
    final emojiMap = {
      'Great': '🤩',
      'Good': '😊',
      'Neutral': '😐',
      'Low': '🥱',
      'Exhausted': '😫',
    };

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
                      moodEntry != null ? emojiMap[moodEntry.mood] ?? '😊' : '?',
                      style: const TextStyle(fontSize: 18),
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
                  moodEntry?.mood ?? 'Not Set',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  moodEntry != null ? 'Feeling ${moodEntry.mood.toLowerCase()}!' : 'How are you feeling?',
                  style: TextStyle(
                    fontSize: 14,
                    color: (isNight ? Colors.white : HelioColors.dayText).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (isNight ? HelioColors.nightPrimary : Colors.green).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                moodEntry != null ? Icons.sentiment_satisfied_rounded : Icons.add_reaction_rounded,
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
    final nextAlarmAsync = ref.watch(nextUpcomingAlarmProvider);
    
    return nextAlarmAsync.when(
      data: (alarm) {
        if (alarm == null) return const SizedBox.shrink();
        
        final h = alarm.alarmTime.hour;
        final m = alarm.alarmTime.minute;
        final hour12 = h % 12 == 0 ? 12 : h % 12;
        final period = h >= 12 ? 'PM' : 'AM';
        final timeStr = '${hour12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';

        return PremiumCard(
          isGlass: isNight,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isNight ? HelioColors.nightPrimary : Colors.orange).withValues(alpha: 0.1),
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
                        color: (isNight ? Colors.white : HelioColors.dayText).withValues(alpha: 0.6),
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
                      alarm.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: (isNight ? Colors.white : HelioColors.dayText).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isNight ? HelioColors.nightPrimary : Colors.green).withValues(alpha: 0.1),
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
    if (hour >= 5 && hour < 12) return 'Good Morning! ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon! 🌤️';
    return 'Good Evening! 🌙';
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
        backgroundColor: isNight ? Colors.white.withValues(alpha: 0.1) : Colors.white,
        foregroundColor: isNight ? Colors.white : HelioColors.dayText,
        elevation: isNight ? 0 : 4,
        shadowColor: HelioColors.dayShadow,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: isNight ? BorderSide(color: Colors.white.withValues(alpha: 0.1)) : null,
      ),
    );
  }
}

class _StreakProgressRing extends StatelessWidget {
  final bool isNight;
  final int streak;
  const _StreakProgressRing({required this.isNight, required this.streak});

  @override
  Widget build(BuildContext context) {
    // Just a visual representation
    final progress = (streak % 7) / 7.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: (progress == 0 && streak > 0) ? 1.0 : progress,
            strokeWidth: 8,
            backgroundColor: (isNight ? Colors.white : HelioColors.dayPrimary).withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
            ),
          ),
        ),
        const Icon(
          Icons.local_fire_department_rounded,
          color: Colors.orange,
          size: 32,
        ),
      ],
    );
  }
}
