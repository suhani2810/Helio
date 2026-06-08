// lib/features/alarms/alarm_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../models/alarm.dart';
import '../../providers/alarm_provider.dart';
import 'create_alarm_screen.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmsAsync = ref.watch(alarmNotifierProvider);

    return Scaffold(
      backgroundColor: HelioColors.backgroundDark,
      body: Stack(
        children: [
          // Ambient glow
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    HelioColors.sunriseOrange.withOpacity(0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ALARMS',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: HelioColors.textOrange,
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            alarmsAsync.when(
                              data: (alarms) => Text(
                                '${alarms.where((a) => a.isEnabled).length} Active',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              loading: () => Text(
                                '—',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      // Add button (header)
                      _AddButton(onTap: () => _navigateToCreate(context)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // List
                Expanded(
                  child: alarmsAsync.when(
                    data: (alarms) => alarms.isEmpty
                        ? _buildEmptyState(context)
                        : _buildList(context, alarms),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: HelioColors.sunriseOrange,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Text(
                        'Error: $e',
                        style: const TextStyle(color: HelioColors.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // FAB
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToCreate(context),
          backgroundColor: HelioColors.sunriseOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'New Alarm',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAlarmScreen()),
    );
  }

  Widget _buildList(BuildContext context, List<Alarm> alarms) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: alarms.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return _AlarmCard(
          alarm: alarms[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateAlarmScreen(initialAlarm: alarms[i]),
            ),
          ),
          onToggle: () => ref
              .read(alarmNotifierProvider.notifier)
              .toggleAlarm(alarms[i].id),
          onDelete: () => ref
              .read(alarmNotifierProvider.notifier)
              .deleteAlarm(alarms[i].id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HelioColors.cardDark,
                border: Border.all(color: HelioColors.divider),
              ),
              child: const Icon(
                Icons.alarm_add_rounded,
                size: 40,
                color: HelioColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No alarms yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: HelioColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Alarm" to create your first wake-up mission.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Alarm Card ─────────────────────────────────────────────────────────────────

class _AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _AlarmCard({
    required this.alarm,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final h = alarm.time.hour;
    final m = alarm.time.minute;
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    final period = h >= 12 ? 'PM' : 'AM';
    final timeStr =
        '${hour12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

    return Dismissible(
      key: ValueKey(alarm.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: HelioColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: HelioColors.error,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: HelioColors.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: alarm.isEnabled
                  ? HelioColors.sunriseOrange.withOpacity(0.25)
                  : HelioColors.divider,
              width: alarm.isEnabled ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    Text(
                      alarm.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: HelioColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Time display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeStr,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: alarm.isEnabled
                                    ? HelioColors.textPrimary
                                    : HelioColors.textTertiary,
                                fontSize: 44,
                                letterSpacing: -2,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7, left: 4),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: alarm.isEnabled
                                  ? HelioColors.textSecondary
                                  : HelioColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Days row + mission badge
                    Row(
                      children: [
                        // Day indicators
                        if (alarm.repeatDays.isNotEmpty) ...[
                          _DayChips(days: alarm.repeatDays),
                          const SizedBox(width: 8),
                        ],
                        if (alarm.missionType != 'None')
                          _MissionPill(type: alarm.missionType),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Toggle
              Column(
                children: [
                  Switch(
                    value: alarm.isEnabled,
                    onChanged: (_) {
                      HapticFeedback.lightImpact();
                      onToggle();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayChips extends StatelessWidget {
  final List<int> days;
  const _DayChips({required this.days});
  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final active = days.contains(i);
        return Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Text(
            _labels[i],
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              color: active
                  ? HelioColors.sunriseOrange
                  : HelioColors.textTertiary,
            ),
          ),
        );
      }),
    );
  }
}

class _MissionPill extends StatelessWidget {
  final String type;
  const _MissionPill({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: HelioColors.glassOrange20,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.bolt_rounded,
            size: 10,
            color: HelioColors.sunriseOrange,
          ),
          const SizedBox(width: 3),
          Text(
            type,
            style: const TextStyle(
              color: HelioColors.sunriseOrange,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: HelioColors.glassOrange20,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HelioColors.sunriseOrange.withOpacity(0.4)),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: HelioColors.sunriseOrange,
          size: 22,
        ),
      ),
    );
  }
}
