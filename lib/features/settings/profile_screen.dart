import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import 'theme_preview_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, isNight ? 280 : 20, 24, 20),
            child: Column(
              children: [
                _buildProfileHeader(context, isNight, textColor),
                const SizedBox(height: 32),
                _buildStatsSection(isNight),
                const SizedBox(height: 32),
                _buildAchievementSection(context, isNight, textColor),
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

  Widget _buildProfileHeader(BuildContext context, bool isNight, Color textColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=suhani'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Suhani Mahajan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: (isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Early Bird Rank: Phoenix',
            style: TextStyle(
              color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(bool isNight) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'Current Streak',
            value: '12 Days',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
            isNight: isNight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatItem(
            label: 'Best Streak',
            value: '30 Days',
            icon: Icons.emoji_events_rounded,
            color: Colors.amber,
            isNight: isNight,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementSection(BuildContext context, bool isNight, Color textColor) {
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
        PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.all(24),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            children: [
              _AchievementBadge(
                icon: Icons.auto_awesome_rounded,
                label: '30 Day Streak',
                isNight: isNight,
              ),
              _AchievementBadge(
                icon: Icons.nightlight_round,
                label: 'Midnight Master',
                isNight: isNight,
              ),
              _AchievementBadge(
                icon: Icons.wb_sunny_rounded,
                label: 'Early Bird',
                isNight: isNight,
              ),
              _AchievementBadge(
                icon: Icons.bolt_rounded,
                label: 'Precision Pro',
                isNight: isNight,
              ),
            ],
          ),
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
          ),
          _SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            isNight: isNight,
          ),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy & Security',
            isNight: isNight,
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
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
    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isNight ? Colors.white : HelioColors.dayText,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: (isNight ? Colors.white : HelioColors.dayText).withOpacity(0.6),
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

  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    final color = isNight ? HelioColors.nightSecondary : HelioColors.daySecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              if (isNight)
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isNight ? Colors.white : HelioColors.dayText,
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
          leading: Icon(icon, color: textColor.withOpacity(0.7)),
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: textColor.withOpacity(0.3)),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 20,
            color: textColor.withOpacity(0.05),
          ),
      ],
    );
  }
}
