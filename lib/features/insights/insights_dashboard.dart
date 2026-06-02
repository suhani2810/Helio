import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class InsightsDashboard extends StatelessWidget {
  const InsightsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HelioColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Insights'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCircadianScore(context),
            const SizedBox(height: 32),
            Text('Sleep Consistency', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildConsistencyChart(context),
            const SizedBox(height: 32),
            Text('Recent Trends', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildTrendList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCircadianScore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HelioColors.sunriseOrange.withOpacity(0.2), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: HelioColors.sunriseOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Circadian Sync',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: HelioColors.sunriseOrange),
                ),
                const Text(
                  'Your rhythm is 85% aligned with the sun.',
                  style: TextStyle(color: HelioColors.textSecondary),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.85,
                  strokeWidth: 8,
                  color: HelioColors.sunriseOrange,
                  backgroundColor: Colors.white10,
                ),
              ),
              Text('85%', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyChart(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final values = [0.8, 0.9, 0.7, 0.4, 0.9, 0.6, 0.8];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HelioColors.cardDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: 120 * values[index],
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [HelioColors.sunriseOrange, HelioColors.softPink],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              Text(days[index], style: const TextStyle(fontSize: 12, color: HelioColors.textSecondary)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTrendList(BuildContext context) {
    final trends = [
      {'title': 'Avg Wake-up', 'value': '6:45 AM', 'trend': '+12m'},
      {'title': 'Deep Sleep', 'value': '2h 15m', 'trend': '-5m'},
      {'title': 'Mood Score', 'value': '8.5/10', 'trend': '+0.5'},
    ];

    return Column(
      children: trends.map((trend) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HelioColors.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(trend['title']!, style: const TextStyle(color: HelioColors.textSecondary)),
              const Spacer(),
              Text(trend['value']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Text(
                trend['trend']!,
                style: TextStyle(
                  color: trend['trend']!.startsWith('+') ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
