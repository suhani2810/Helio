import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../providers/stats_provider.dart';
import '../../providers/repository_providers.dart';
import '../../models/mood_entry_entity.dart';

class MoodTrackingScreen extends ConsumerStatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  ConsumerState<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends ConsumerState<MoodTrackingScreen> {
  String? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Great', 'emoji': '🤩', 'color': Colors.orange},
    {'label': 'Good', 'emoji': '😊', 'color': Colors.yellow},
    {'label': 'Neutral', 'emoji': '😐', 'color': Colors.blue},
    {'label': 'Low', 'emoji': '🥱', 'color': Colors.purple},
    {'label': 'Exhausted', 'emoji': '😫', 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    final moodHistoryAsync = ref.watch(_moodHistoryProvider);

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
                Text(
                  'Weekly Mood Chart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildWeeklyChart(isNight, textColor, primaryColor),
                const SizedBox(height: 40),
                _buildStatisticsRow(isNight, textColor),
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
      height: 130,
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
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? moodColor.withOpacity(0.2) 
                        : (isNight ? Colors.white.withOpacity(0.05) : Colors.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? moodColor : textColor.withOpacity(0.1),
                      width: 2.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: moodColor.withOpacity(0.3),
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
                    color: isSelected ? textColor : textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyChart(bool isNight, Color textColor, Color primaryColor) {
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final heights = [0.4, 0.8, 0.6, 0.9, 0.7, 0.5, 0.8];
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 14,
                  height: 100 * heights[index],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(bool isNight, Color textColor) {
    final streakAsync = ref.watch(streakNotifierProvider);
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Streak',
            value: streakAsync.when(data: (s) => '$s Days', loading: () => '—', error: (_, __) => '—'),
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
            value: 'Energized',
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
          'No history yet',
          style: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      );
    }
    return Column(
      children: history.map((item) {
        final dateStr = item.date.day == DateTime.now().day ? 'Today' : '${item.date.day}/${item.date.month}';
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.mood,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
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

final _moodHistoryProvider = FutureProvider<List<MoodEntryEntity>>((ref) {
  return ref.watch(moodRepositoryProvider).getMoodHistory();
});

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
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
