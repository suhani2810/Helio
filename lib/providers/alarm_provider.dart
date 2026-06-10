import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/alarm_entity.dart';
import 'repository_providers.dart';
import '../core/services/notification_service.dart';

part 'alarm_provider.g.dart';

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  Future<List<AlarmEntity>> build() async {
    final repository = ref.watch(alarmRepositoryProvider);
    final alarms = await repository.getAllAlarms();
    
    // Sync scheduled alarms on startup
    _rescheduleAllActive(alarms);
    
    return alarms;
  }

  Future<void> _rescheduleAllActive(List<AlarmEntity> alarms) async {
    final scheduler = ref.read(alarmSchedulerServiceProvider);
    for (var alarm in alarms) {
      if (alarm.enabled) {
        await scheduler.scheduleAlarm(alarm);
      } else {
        await scheduler.cancelAlarm(alarm.id);
      }
    }
  }

  Future<void> addAlarm(AlarmEntity alarm) async {
    final repository = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerServiceProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveAlarm(alarm);
      if (alarm.enabled) {
        await scheduler.scheduleAlarm(alarm);
        await NotificationService().showAlarmEnabledConfirmation(alarm.alarmTime);
      }
      return repository.getAllAlarms();
    });
  }

  Future<void> updateAlarm(AlarmEntity alarm) async {
    final repository = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerServiceProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.saveAlarm(alarm);
      if (alarm.enabled) {
        await scheduler.scheduleAlarm(alarm);
        await NotificationService().showAlarmEnabledConfirmation(alarm.alarmTime);
      } else {
        await scheduler.cancelAlarm(alarm.id);
      }
      return repository.getAllAlarms();
    });
  }

  Future<void> deleteAlarm(int id) async {
    final repository = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerServiceProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await scheduler.cancelAlarm(id);
      await repository.deleteAlarm(id);
      return repository.getAllAlarms();
    });
  }

  Future<void> toggleAlarm(int id) async {
    final repository = ref.read(alarmRepositoryProvider);
    final scheduler = ref.read(alarmSchedulerServiceProvider);
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final alarm = await repository.getAlarm(id);
      if (alarm != null) {
        alarm.enabled = !alarm.enabled;
        await repository.saveAlarm(alarm);
        if (alarm.enabled) {
          await scheduler.scheduleAlarm(alarm);
          await NotificationService().showAlarmEnabledConfirmation(alarm.alarmTime);
        } else {
          await scheduler.cancelAlarm(alarm.id);
        }
      }
      return repository.getAllAlarms();
    });
  }
}

@riverpod
Future<AlarmEntity?> nextUpcomingAlarm(NextUpcomingAlarmRef ref) async {
  final alarmsAsync = ref.watch(alarmNotifierProvider);
  return alarmsAsync.when(
    data: (alarms) {
      final active = alarms.where((a) => a.enabled).toList();
      if (active.isEmpty) return null;
      
      final now = DateTime.now();
      active.sort((a, b) {
        final nextA = _calcNext(a, now);
        final nextB = _calcNext(b, now);
        return nextA.compareTo(nextB);
      });
      return active.first;
    },
    loading: () => null,
    error: (_, _) => null,
  );
}

DateTime _calcNext(AlarmEntity alarm, DateTime now) {
  // For one-time alarms
  if (alarm.repeatDays.isEmpty) {
    if (alarm.alarmTime.isAfter(now)) {
      return alarm.alarmTime;
    }
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.alarmTime.hour,
      alarm.alarmTime.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // For repeat alarms
  int currentIsarWeekday = now.weekday - 1; // 0=Mon, 6=Sun
  for (int i = 0; i < 8; i++) {
    int checkIsarWeekday = (currentIsarWeekday + i) % 7;
    if (alarm.repeatDays.contains(checkIsarWeekday)) {
      DateTime potentialScheduled = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.alarmTime.hour,
        alarm.alarmTime.minute,
      ).add(Duration(days: i));

      if (potentialScheduled.isAfter(now)) {
        return potentialScheduled;
      }
    }
  }

  DateTime scheduled = DateTime(
    now.year,
    now.month,
    now.day,
    alarm.alarmTime.hour,
    alarm.alarmTime.minute,
  );
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}
