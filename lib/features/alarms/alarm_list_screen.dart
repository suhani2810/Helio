import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../models/alarm_entity.dart';
import '../../providers/alarm_provider.dart';
import '../../providers/time_provider.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import 'create_alarm_screen.dart';
import 'alarm_ringing_screen.dart';

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
    final themeMode = ref.watch(themeControllerProvider);
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
    final isNight = _isNightMode(themeMode, now.hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNight) const SizedBox(height: 260),
              // Header
                Padding(
                padding: EdgeInsets.fromLTRB(24, isNight ? 0 : 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ALARMS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              alarmsAsync.when(
                                data: (alarms) => Text(
                                  '${alarms.where((a) => a.enabled).length} Active',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                loading: () => Text(
                                  '—',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: textColor),
                                ),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        _AddButton(
                          onTap: () => _navigateToCreate(context),
                          isNight: isNight,
                        ),
                      ],
                    ),
                    // Task 3: Developer Testing Trigger
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextButton.icon(
                        onPressed: () => _triggerTestAlarm(ref),
                        icon: const Icon(Icons.bug_report_rounded, size: 16),
                        label: const Text('TRIGGER ALARM NOW (DEV)'),
                        style: TextButton.styleFrom(
                          foregroundColor: isNight ? Colors.orange : Colors.deepOrange,
                          textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // List
              Expanded(
                child: alarmsAsync.when(
                  data: (alarms) => alarms.isEmpty
                      ? _buildEmptyState(context, isNight, textColor)
                      : _buildList(context, alarms, isNight),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                      strokeWidth: 3,
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
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToCreate(context),
          backgroundColor: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
          foregroundColor: Colors.white,
          elevation: 8,
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

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }

  void _navigateToCreate(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAlarmScreen()),
    );
  }

  // Task 3: Temporary Developer Testing Method
  void _triggerTestAlarm(WidgetRef ref) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Scheduling native test alarm for 2 seconds in the future...'),
        duration: Duration(seconds: 1),
      ),
    );

    final testAlarm = AlarmEntity(
      label: 'DEV-TEST: Quick Alarm',
      alarmTime: DateTime.now().add(const Duration(seconds: 2)),
      enabled: true,
      repeatDays: const [],
      ringtone: 'Default',
      missionType: 'Math',
      mathDifficulty: 0, // Easy
      mathQuestionsCount: 1, // 1 question
      createdAt: DateTime.now(),
    );

    await ref.read(alarmNotifierProvider.notifier).addAlarm(testAlarm);
  }

  Widget _buildList(BuildContext context, List<AlarmEntity> alarms, bool isNight) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: alarms.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, i) {
        return _AlarmCard(
          alarm: alarms[i],
          isNight: isNight,
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


  Widget _buildEmptyState(BuildContext context, bool isNight, Color textColor) {
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
                color: isNight ? Colors.white.withOpacity(0.05) : Colors.white,
                border: Border.all(color: isNight ? Colors.white24 : Colors.black12),
              ),
              child: Icon(
                Icons.alarm_add_rounded,
                size: 40,
                color: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No alarms yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Alarm" to create your first wake-up mission.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final AlarmEntity alarm;
  final bool isNight;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _AlarmCard({
    required this.alarm,
    required this.isNight,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final h = alarm.alarmTime.hour;
    final m = alarm.alarmTime.minute;
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    final period = h >= 12 ? 'PM' : 'AM';
    final timeStr = '${hour12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    final textColor = isNight ? Colors.white : HelioColors.dayText;

    return Dismissible(
      key: ValueKey(alarm.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.redAccent,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          isGlass: isNight,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alarm.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: alarm.enabled ? textColor : textColor.withOpacity(0.3),
                            letterSpacing: -1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            period,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: alarm.enabled ? textColor.withOpacity(0.7) : textColor.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (alarm.repeatDays.isNotEmpty) ...[
                          _DayChips(days: alarm.repeatDays, isNight: isNight),
                          const SizedBox(width: 12),
                        ],
                        if (alarm.missionType != 'None')
                          _MissionPill(type: alarm.missionType, isNight: isNight),
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: alarm.enabled,
                activeColor: isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary,
                onChanged: (_) {
                  HapticFeedback.lightImpact();
                  onToggle();
                },
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
  final bool isNight;
  const _DayChips({required this.days, required this.isNight});
  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final activeColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    return Row(
      children: List.generate(7, (i) {
        final active = days.contains(i);
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            _labels[i],
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w900 : FontWeight.w400,
              color: active ? activeColor : (isNight ? Colors.white30 : Colors.black26),
            ),
          ),
        );
      }),
    );
  }
}

class _MissionPill extends StatelessWidget {
  final String type;
  final bool isNight;
  const _MissionPill({required this.type, required this.isNight});

  @override
  Widget build(BuildContext context) {
    final color = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isNight;
  const _AddButton({required this.onTap, required this.isNight});

  @override
  Widget build(BuildContext context) {
    final color = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(Icons.add_rounded, color: color, size: 28),
      ),
    );
  }
}
