import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
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
    return Scaffold(
      backgroundColor: HelioColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              const SizedBox(height: 20),
              Text('How is your morning?', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),
              _buildMoodSelector(),
              const SizedBox(height: 40),
              Text('Weekly Mood Chart', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildWeeklyChart(),
              const SizedBox(height: 40),
              _buildStatisticsRow(),
              const SizedBox(height: 40),
              Text('Mood History', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildHistoryTimeline(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedMood != null ? () => Navigator.pop(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HelioColors.sunriseOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save for Today', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _moods.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = _selectedMood == mood['label'];
          return GestureDetector(
            onTap: () => setState(() => _selectedMood = mood['label'] as String),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? (mood['color'] as Color).withOpacity(0.2) : HelioColors.cardDark,
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? mood['color'] as Color : Colors.transparent, width: 2),
                  ),
                  child: Text(mood['emoji'] as String, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 4),
                Text(
                  mood['label'] as String,
                  style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : HelioColors.textSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: HelioColors.cardDark, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final heights = [0.4, 0.8, 0.6, 0.9, 0.7, 0.5, 0.8];
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 12,
                height: 100 * heights[index],
                decoration: BoxDecoration(
                  color: HelioColors.sunriseOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][index], style: const TextStyle(fontSize: 10)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        _buildStatCard('Streak', '5 Days', Icons.local_fire_department),
        const SizedBox(width: 16),
        _buildStatCard('Most Frequent', 'Energized', Icons.mood),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: HelioColors.cardDark, borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: [
            Icon(icon, color: HelioColors.morningYellow),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 10, color: HelioColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTimeline() {
    final history = [
      {'date': 'Today', 'mood': 'Excellent', 'time': '7:00 AM'},
      {'date': 'Yesterday', 'mood': 'Good', 'time': '6:45 AM'},
      {'date': 'Jan 30', 'mood': 'Stressed', 'time': '8:15 AM'},
    ];

    return Column(
      children: history.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: HelioColors.sunriseOrange.withOpacity(0.3), width: 2)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['date']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(item['time']!, style: const TextStyle(fontSize: 12, color: HelioColors.textSecondary)),
                ],
              ),
              const Spacer(),
              Text(item['mood']!, style: const TextStyle(color: HelioColors.morningYellow)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
