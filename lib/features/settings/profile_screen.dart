import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/stats_provider.dart';
import 'theme_preview_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    final rankAsync = ref.watch(userRankProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, isNight ? 280 : 20, 24, 20),
            child: Column(
              children: [
                rankAsync.when(
                  data: (rank) => _buildProfileHeader(context, isNight, textColor, rank),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 32),
                _buildStatsSection(context, ref, isNight),
                const SizedBox(height: 32),
                _buildAchievementSection(context, ref, isNight, textColor),
                const SizedBox(height: 32),
                _buildSettingsSection(context, isNight, textColor),
                const SizedBox(height: 100),
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

  Widget _buildProfileHeader(BuildContext context, bool isNight, Color textColor, Map<String, dynamic> rank) {
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return Column(
      children: [
        Text(
          'Suhani Mahajan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Rank: ${rank['title']}',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Next Rank',
                      style: TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${rank['wakeups']} / ${rank['nextGoal']} wakeups',
                      style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: rank['progress'] as double,
                  minHeight: 6,
                  color: primaryColor,
                  backgroundColor: textColor.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, WidgetRef ref, bool isNight) {
    final currentStreak = ref.watch(streakNotifierProvider).value ?? 0;
    final bestStreakVal = ref.watch(bestStreakProvider).value ?? 0;
    final totalAlarms = ref.watch(totalAlarmsCreatedProvider).value ?? 0;
    final completedMissionsVal = ref.watch(completedMissionsProvider).value ?? 0;
    final moodLogsVal = ref.watch(moodLogsCountProvider).value ?? 0;
    final avgDelay = ref.watch(averageWakeupDelayProvider).value ?? 0.0;

    final stats = [
      {
        'label': 'Current Streak',
        'value': '$currentStreak Days',
        'icon': Icons.local_fire_department_rounded,
        'color': Colors.orange,
      },
      {
        'label': 'Best Streak',
        'value': '$bestStreakVal Days',
        'icon': Icons.emoji_events_rounded,
        'color': Colors.amber,
      },
      {
        'label': 'Completed Missions',
        'value': '$completedMissionsVal Done',
        'icon': Icons.bolt_rounded,
        'color': Colors.purple,
      },
      {
        'label': 'Mood Logs',
        'value': '$moodLogsVal Recorded',
        'icon': Icons.mood_rounded,
        'color': Colors.pink,
      },
      {
        'label': 'Avg Wake-up Delay',
        'value': '${avgDelay.toStringAsFixed(1)} min',
        'icon': Icons.timer_rounded,
        'color': Colors.indigo,
      },
      {
        'label': 'Total Alarms',
        'value': '$totalAlarms Set',
        'icon': Icons.alarm_rounded,
        'color': Colors.blue,
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final double childAspectRatio = screenWidth < 360 ? 1.05 : 1.25;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        return _StatItem(
          label: item['label'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
          isNight: isNight,
        );
      },
    );
  }

  Widget _buildAchievementSection(BuildContext context, WidgetRef ref, bool isNight, Color textColor) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ),
        achievementsAsync.when(
          data: (list) => PremiumCard(
            isGlass: isNight,
            padding: const EdgeInsets.all(24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32,
                crossAxisSpacing: 24,
                childAspectRatio: 0.85,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final achievement = list[index];
                final unlockedAt = achievement['unlockedAt'] as DateTime?;
                String? dateStr;
                if (unlockedAt != null) {
                  dateStr = DateFormat('MMM d, yyyy').format(unlockedAt);
                }

                return _AchievementBadge(
                  icon: achievement['icon'] as IconData,
                  label: achievement['title'] as String,
                  isNight: isNight,
                  isUnlocked: achievement['isUnlocked'] as bool,
                  progress: achievement['progress'] as double,
                  unlockedDate: dateStr,
                );
              },
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, bool isNight, Color textColor) {
    return PremiumCard(
      isGlass: isNight,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Customization',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThemePreviewScreen()),
            ),
            isNight: isNight,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isNight;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isNight;
  final bool isUnlocked;
  final double progress;
  final String? unlockedDate;

  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.isNight,
    required this.isUnlocked,
    required this.progress,
    this.unlockedDate,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final color = isUnlocked ? primaryColor : textColor.withValues(alpha: 0.2);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                color: color,
                backgroundColor: textColor.withValues(alpha: 0.05),
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
                boxShadow: [
                  if (isUnlocked && isNight)
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(icon, color: isUnlocked ? color : textColor.withValues(alpha: 0.3), size: 28),
            ),
            if (isUnlocked)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isUnlocked ? textColor : textColor.withValues(alpha: 0.4),
          ),
        ),
        if (unlockedDate != null)
          Text(
            unlockedDate!,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isNight;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    required this.isNight,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Icon(icon, color: textColor.withValues(alpha: 0.7)),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.3)),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 20,
            color: textColor.withValues(alpha: 0.05),
          ),
      ],
    );
  }
}
