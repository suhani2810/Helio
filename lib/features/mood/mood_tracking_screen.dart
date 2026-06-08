import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class MoodTrackingScreen extends ConsumerStatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  ConsumerState<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends ConsumerState<MoodTrackingScreen> {
  String? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Excellent', 'emoji': '🤩', 'color': Colors.orange},
    {'label': 'Good', 'emoji': '😊', 'color': Colors.yellow},
    {'label': 'Okay', 'emoji': '😐', 'color': Colors.blue},
    {'label': 'Tired', 'emoji': '🥱', 'color': Colors.purple},
    {'label': 'Stressed', 'emoji': '😫', 'color': Colors.red},
  ];

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
                        onPressed: () => Navigator.pop(context),
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
                _buildHistoryTimeline(isNight, textColor, primaryColor),
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
      height: 110,
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
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Streak',
            value: '5 Days',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            isNight: isNight,
            textColor: textColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Frequent',
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

  Widget _buildHistoryTimeline(bool isNight, Color textColor, Color primaryColor) {
    final history = [
      {'date': 'Today', 'mood': 'Excellent', 'time': '7:00 AM'},
      {'date': 'Yesterday', 'mood': 'Good', 'time': '6:45 AM'},
      {'date': 'Jan 30', 'mood': 'Stressed', 'time': '8:15 AM'},
    ];

    return Column(
      children: history.map((item) {
        return PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['date']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  Text(
                    item['time']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.5),
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
                  item['mood']!,
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
