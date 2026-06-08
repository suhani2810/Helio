import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';

class InsightsDashboard extends ConsumerWidget {
  const InsightsDashboard({super.key});

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
                _buildCircadianScore(context, isNight, textColor),
                const SizedBox(height: 32),
                Text(
                  'Sleep Consistency',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildConsistencyChart(context, isNight, textColor),
                const SizedBox(height: 32),
                Text(
                  'Recent Trends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTrendList(context, isNight, textColor),
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

  Widget _buildCircadianScore(BuildContext context, bool isNight, Color textColor) {
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    
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
                  'Circadian Sync',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your rhythm is 85% aligned with the sun.',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
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
                  value: 0.85,
                  strokeWidth: 10,
                  color: isNight ? HelioColors.nightSecondary : HelioColors.daySecondary,
                  backgroundColor: textColor.withOpacity(0.1),
                ),
              ),
              Text(
                '85%',
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

  Widget _buildConsistencyChart(BuildContext context, bool isNight, Color textColor) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final values = [0.8, 0.9, 0.7, 0.4, 0.9, 0.6, 0.8];
    final barColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return PremiumCard(
      isGlass: isNight,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: 140 * values[index],
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [barColor, barColor.withOpacity(0.4)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (isNight)
                          BoxShadow(
                            color: barColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    days[index],
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
        ],
      ),
    );
  }

  Widget _buildTrendList(BuildContext context, bool isNight, Color textColor) {
    final trends = [
      {'title': 'Avg Wake-up', 'value': '6:45 AM', 'trend': '+12m', 'isGood': true},
      {'title': 'Deep Sleep', 'value': '2h 15m', 'trend': '-5m', 'isGood': false},
      {'title': 'Mood Score', 'value': '8.5/10', 'trend': '+0.5', 'isGood': true},
    ];

    return Column(
      children: trends.map((trend) {
        final isGood = trend['isGood'] as bool;
        return PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Text(
                trend['title'] as String,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                trend['value'] as String,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isGood ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend['trend'] as String,
                  style: TextStyle(
                    color: isGood ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
