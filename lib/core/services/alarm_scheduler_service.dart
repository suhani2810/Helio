import 'package:alarm/alarm.dart';
import '../../models/alarm_entity.dart';
import 'notification_service.dart';

class AlarmSchedulerService {
  static Future<void> init() async {
    await Alarm.init();
  }

  Future<void> scheduleAlarm(AlarmEntity alarmEntity) async {
    // Find next instance of the alarm
    DateTime scheduledDateTime = _calculateNextInstance(alarmEntity);

    final alarmSettings = AlarmSettings(
      id: alarmEntity.id,
      dateTime: scheduledDateTime,
      assetAudioPath: _getRingtonePath(alarmEntity.ringtone),
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationSettings: NotificationSettings(
        title: alarmEntity.label,
        body: 'Wake up mission: ${alarmEntity.missionType}',
        stopButton: 'Stop',
      ),
      warningNotificationOnKill: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);

    // Schedule exact notification to wake up device exactly on time and ensure sub-second accuracy
    await NotificationService().scheduleExactAlarmNotification(
      id: alarmEntity.id,
      scheduledTime: scheduledDateTime,
      title: alarmEntity.label,
      body: 'Wake up mission: ${alarmEntity.missionType}',
    );
  }

  Future<void> cancelAlarm(int id) async {
    await Alarm.stop(id);
    await NotificationService().cancelNotification(id);
  }

  Future<void> cancelAll() async {
    final all = await Alarm.getAlarms();
    for (var a in all) {
      await Alarm.stop(a.id);
      await NotificationService().cancelNotification(a.id);
    }
  }

  DateTime _calculateNextInstance(AlarmEntity alarm) {
    final now = DateTime.now();
    
    // For one-time alarms (e.g. snoozes, follow-ups, dev tests)
    if (alarm.repeatDays.isEmpty) {
      if (alarm.alarmTime.isAfter(now)) {
        return alarm.alarmTime;
      }
      // If the time set is in the past, schedule it for tomorrow
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

    // Fallback: tomorrow at that time
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

  String _getRingtonePath(String ringtone) {
    if (ringtone.startsWith('assets/audio/')) {
      return ringtone;
    }
    return 'assets/audio/Classic.mp3';
  }
}
