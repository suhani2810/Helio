import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/stats_provider.dart';
import '../../providers/alarm_provider.dart';

class InsightsDashboard extends ConsumerWidget {
  const InsightsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    final streakAsync = ref.watch(streakNotifierProvider);
    final bestStreakAsync = ref.watch(bestStreakProvider);
    final totalWakeupsAsync = ref.watch(totalWakeupsProvider);
    final alarmsAsync = ref.watch(alarmNotifierProvider);
    final missionStatsAsync = ref.watch(missionStatsProvider);
    final consistencyAsync = ref.watch(wakeupConsistencyProvider);
    final mostUsedAsync = ref.watch(mostUsedMissionProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, isNight ? 280 : 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insights',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                _buildConsistencyScore(context, isNight, textColor, consistencyAsync),
                const SizedBox(height: 32),
                Text(
                  'Mission Distribution',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                missionStatsAsync.when(
                  data: (stats) => _buildMissionStatsChart(context, isNight, textColor, stats),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error loading stats: $e'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickStats(
                  context, 
                  isNight, 
                  textColor, 
                  alarmsAsync, 
                  totalWakeupsAsync,
                  streakAsync,
                  bestStreakAsync,
                  mostUsedAsync,
                ),
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

  Widget _buildConsistencyScore(
    BuildContext context, 
    bool isNight, 
    Color textColor,
    AsyncValue<double> consistency,
  ) {
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    final score = consistency.value ?? 0.0;
    
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wake-up Score',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your consistency is based on mission delay.',
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: score / 100.0,
                  strokeWidth: 10,
                  color: isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                  backgroundColor: textColor.withValues(alpha: 0.1),
                ),
              ),
              Text(
                '${score.toInt()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionStatsChart(BuildContext context, bool isNight, Color textColor, Map<String, int> stats) {
    final barColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    if (stats.isEmpty) {
      return PremiumCard(
        isGlass: isNight,
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Complete missions to see stats',
            style: TextStyle(color: textColor.withValues(alpha: 0.5)),
          ),
        ),
      );
    }

    final sortedStats = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sortedStats.first.value;

    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: sortedStats.map((entry) {
          final progress = entry.value / maxVal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    Text(
                      '${entry.value}',
                      style: TextStyle(color: barColor, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: barColor,
                    backgroundColor: textColor.withValues(alpha: 0.05),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    bool isNight,
    Color textColor,
    AsyncValue<List<dynamic>> alarms,
    AsyncValue<int> totalWakeups,
    AsyncValue<int> streak,
    AsyncValue<int> bestStreak,
    AsyncValue<String> mostUsed,
  ) {
    final totalAlarms = alarms.value?.length ?? 0;
    final wakeups = totalWakeups.value ?? 0;

    final trends = [
      {'title': 'Total Alarms', 'value': '$totalAlarms', 'icon': Icons.alarm_rounded, 'color': Colors.blue},
      {'title': 'Total Wakeups', 'value': '$wakeups', 'icon': Icons.wb_sunny_rounded, 'color': Colors.orange},
      {'title': 'Current Streak', 'value': '${streak.value ?? 0} d', 'icon': Icons.local_fire_department_rounded, 'color': Colors.red},
      {'title': 'Best Streak', 'value': '${bestStreak.value ?? 0} d', 'icon': Icons.emoji_events_rounded, 'color': Colors.amber},
      {'title': 'Top Mission', 'value': mostUsed.value ?? 'None', 'icon': Icons.bolt_rounded, 'color': Colors.purple},
    ];

    return Column(
      children: trends.map((trend) {
        return PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (trend['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(trend['icon'] as IconData, color: trend['color'] as Color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                trend['title'] as String,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                trend['value'] as String,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
