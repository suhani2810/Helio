import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../models/alarm.dart';
import '../../providers/alarm_provider.dart';
import 'create_alarm_screen.dart';

class AlarmListScreen extends ConsumerWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmNotifierProvider);

    return Scaffold(
      backgroundColor: HelioColors.backgroundDark,
      appBar: AppBar(
        title: const Text('My Alarms'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: alarmsAsync.when(
        data: (alarms) => alarms.isEmpty
            ? _buildEmptyState(context)
            : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: alarms.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return _buildAlarmCard(context, ref, alarm);
                },
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: HelioColors.sunriseOrange),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAlarmScreen()),
          );
        },
        backgroundColor: HelioColors.sunriseOrange,
        icon: const Icon(Icons.add),
        label: const Text('Add Alarm'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'No alarms set yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: HelioColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to create your first sunrise.',
            style: TextStyle(color: HelioColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(BuildContext context, WidgetRef ref, Alarm alarm) {
    final timeStr =
        '${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HelioColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: alarm.isEnabled
              ? HelioColors.sunriseOrange.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.title,
                  style: const TextStyle(
                    color: HelioColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: alarm.isEnabled
                        ? HelioColors.textPrimary
                        : HelioColors.textSecondary,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 4),
                _buildMissionBadge(alarm.missionType),
              ],
            ),
          ),
          Switch(
            value: alarm.isEnabled,
            onChanged: (value) =>
                ref.read(alarmNotifierProvider.notifier).toggleAlarm(alarm.id),
            activeThumbColor: HelioColors.sunriseOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionBadge(String type) {
    if (type == 'None') return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: HelioColors.sunriseOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, size: 12, color: HelioColors.sunriseOrange),
          const SizedBox(width: 4),
          Text(
            type,
            style: const TextStyle(
              color: HelioColors.sunriseOrange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
