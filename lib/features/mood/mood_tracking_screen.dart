import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/stats_provider.dart';
import '../../models/mood_entry_entity.dart';

class MoodTrackingScreen extends ConsumerStatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  ConsumerState<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends ConsumerState<MoodTrackingScreen> {
  String? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Energized', 'emoji': '🔥', 'color': Colors.orange},
    {'label': 'Happy', 'emoji': '😊', 'color': Colors.yellow},
    {'label': 'Calm', 'emoji': '😌', 'color': Colors.blue},
    {'label': 'Tired', 'emoji': '🥱', 'color': Colors.purple},
    {'label': 'Stressed', 'emoji': '😫', 'color': Colors.red},
  ];

  String _getStatus(String? mood) {
    if (mood == null) return 'Not Set';
    switch (mood) {
      case 'Happy': return 'Positive';
      case 'Calm': return 'Balanced';
      case 'Tired': return 'Low Energy';
      case 'Stressed': return 'Low';
      case 'Energized': return 'High Energy';
      default: return 'Stable';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    final moodHistoryAsync = ref.watch(moodHistoryProvider);
    final moodTrendAsync = ref.watch(moodTrendProvider);
    final statusAsync = ref.watch(moodStatusProvider);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: textColor),
                    ),
                    if (_selectedMood != null)
                      TextButton(
                        onPressed: () async {
                          await ref.read(moodNotifierProvider.notifier).setMood(_selectedMood!);
                          if (mounted) Navigator.pop(context);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'How is your morning?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMoodSelector(isNight, textColor),
                const SizedBox(height: 40),
                _buildStatisticsRow(isNight, textColor, statusAsync),
                const SizedBox(height: 40),
                Text(
                  'Mood Analytics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAnalyticsGrid(isNight, textColor),
                const SizedBox(height: 40),
                Text(
                  'Weekly Mood Chart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildWeeklyChart(isNight, textColor, primaryColor, moodTrendAsync),
                const SizedBox(height: 40),
                Text(
                  'Mood History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                moodHistoryAsync.when(
                  data: (history) => _buildHistoryTimeline(history, isNight, textColor, primaryColor),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
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

  Widget _buildMoodSelector(bool isNight, Color textColor) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _moods.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = _selectedMood == mood['label'];
          final moodColor = mood['color'] as Color;

          return GestureDetector(
            onTap: () => setState(() => _selectedMood = mood['label'] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? moodColor.withValues(alpha: 0.2) 
                        : (isNight ? Colors.white.withValues(alpha: 0.05) : Colors.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? moodColor : textColor.withValues(alpha: 0.1),
                      width: 2.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: moodColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                    ],
                  ),
                  child: Text(
                    mood['emoji'] as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mood['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? textColor : textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsGrid(bool isNight, Color textColor) {
    final avgAsync = ref.watch(averageMoodScoreProvider);
    final highAsync = ref.watch(highestMoodProvider);
    final lowAsync = ref.watch(lowestMoodProvider);
    final trendAsync = ref.watch(moodTrendLabelProvider);

    final analytics = [
      {'label': 'Average Mood', 'value': avgAsync.when(data: (v) => v.toStringAsFixed(1), loading: () => '—', error: (_, _) => '—'), 'icon': Icons.analytics_rounded, 'color': Colors.blue},
      {'label': 'Highest Mood', 'value': highAsync.value ?? '—', 'icon': Icons.trending_up_rounded, 'color': Colors.green},
      {'label': 'Lowest Mood', 'value': lowAsync.value ?? '—', 'icon': Icons.trending_down_rounded, 'color': Colors.red},
      {'label': '7-Day Trend', 'value': trendAsync.value ?? 'Stable', 'icon': Icons.timeline_rounded, 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: analytics.length,
      itemBuilder: (context, index) {
        final item = analytics[index];
        return PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'] as IconData, color: item['color'] as Color, size: 18),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item['value'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        );
      },
    );
  }

  Widget _buildWeeklyChart(bool isNight, Color textColor, Color primaryColor, AsyncValue<List<double>> trendAsync) {
    final list = trendAsync.value ?? List.filled(7, 0.0);
    final weekdays = <String>[];
    final now = DateTime.now();
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      weekdays.add(dayLabels[date.weekday - 1]);
    }

    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final val = index < list.length ? list[index] : 0.0;
            final hVal = val == 0.0 ? 4.0 : 100.0 * val;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 14,
                  height: hVal,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withValues(alpha: 0.5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  weekdays[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(bool isNight, Color textColor, AsyncValue<String> statusAsync) {
    final streakAsync = ref.watch(streakNotifierProvider);
    final status = statusAsync.value ?? 'Not Set';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Streak',
            value: streakAsync.when(data: (s) => '$s Days', loading: () => '—', error: (_, _) => '—'),
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            isNight: isNight,
            textColor: textColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Status',
            value: status,
            icon: Icons.mood_rounded,
            color: Colors.amber,
            isNight: isNight,
            textColor: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTimeline(List<MoodEntryEntity> history, bool isNight, Color textColor, Color primaryColor) {
    if (history.isEmpty) {
      return Center(
        child: Text(
          'No mood history yet.',
          style: TextStyle(color: textColor.withValues(alpha: 0.5)),
        ),
      );
    }
    return Column(
      children: history.map((item) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final entryDate = DateTime(item.date.year, item.date.month, item.date.day);
        
        String dateStr;
        if (entryDate == today) {
          dateStr = 'Today';
        } else if (entryDate == today.subtract(const Duration(days: 1))) {
          dateStr = 'Yesterday';
        } else {
          dateStr = DateFormat('MMMM d').format(item.date);
        }

        return PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                constraints: const BoxConstraints(maxWidth: 100),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.mood,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}



class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isNight;
  final Color textColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isNight,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
