import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import 'theme_preview_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: HelioColors.sunriseOrange,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Suhani Mahajan', style: Theme.of(context).textTheme.displayMedium),
            Text('Early Bird Rank: Phoenix', style: TextStyle(color: HelioColors.morningYellow, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildStatsGrid(),
            const SizedBox(height: 40),
            _buildAchievementSection(context),
            const SizedBox(height: 40),
            _buildSettingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        _buildStatCard('Streak', '12 Days', Icons.local_fire_department, Colors.orange),
        const SizedBox(width: 16),
        _buildStatCard('Wake-up', '6:30 AM', Icons.wb_sunny, Colors.yellow),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HelioColors.cardDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: HelioColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildBadge(Icons.auto_awesome, '30 Day Streak'),
              _buildBadge(Icons.bedtime, 'Midnight Master'),
              _buildBadge(Icons.access_alarm, 'Precision Pro'),
              _buildBadge(Icons.directions_walk, 'Walk Hero'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: HelioColors.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: HelioColors.morningYellow),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: HelioColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final settings = [
      {
        'title': 'Cuztomization',
        'icon': Icons.palette_outlined,
        'screen': const ThemePreviewScreen()
      },
      {'title': 'Notifications', 'icon': Icons.notifications_active_outlined},
      {'title': 'Device Integration', 'icon': Icons.watch},
      {'title': 'Privacy & Security', 'icon': Icons.lock_outline},
    ];

    return Column(
      children: settings.map((s) {
        return ListTile(
          leading: Icon(s['icon'] as IconData, color: HelioColors.textSecondary),
          title: Text(s['title'] as String),
          trailing: const Icon(Icons.chevron_right, color: HelioColors.textSecondary),
          onTap: s.containsKey('screen') 
              ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => s['screen'] as Widget))
              : null,
        );
      }).toList(),
    );
  }
}
