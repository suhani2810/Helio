import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import '../../models/alarm_entity.dart';

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
  }

  Future<void> cancelAlarm(int id) async {
    await Alarm.stop(id);
  }

  Future<void> cancelAll() async {
    final all = await Alarm.getAlarms();
    for (var a in all) {
      await Alarm.stop(a.id);
    }
  }

  DateTime _calculateNextInstance(AlarmEntity alarm) {
    final now = DateTime.now();
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

    if (alarm.repeatDays.isNotEmpty) {
      // Find next day in repeatDays
      // Isar stores 0=Mon, 6=Sun. DateTime weekday is 1=Mon, 7=Sun.
      int currentWeekday = now.weekday; // 1-7
      int isarWeekday = currentWeekday - 1; // 0-6

      int daysToAdd = 0;
      for (int i = 0; i < 8; i++) {
        int checkDay = (isarWeekday + i) % 7;
        if (alarm.repeatDays.contains(checkDay)) {
          if (i == 0 && scheduled.isAfter(now)) {
            daysToAdd = 0;
            break;
          } else if (i > 0) {
            daysToAdd = i;
            break;
          }
        }
      }
      
      if (daysToAdd > 0 || scheduled.isBefore(now)) {
         // Re-calculate if we need to jump to next week or next repeat day
         // If i=0 but scheduled is before now, we need to find next day.
         if (daysToAdd == 0 && scheduled.isBefore(now)) {
            // Find next repeat day starting tomorrow
            for (int i = 1; i < 8; i++) {
              int checkDay = (isarWeekday + i) % 7;
              if (alarm.repeatDays.contains(checkDay)) {
                daysToAdd = i;
                break;
              }
            }
         }
      }
      scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        alarm.alarmTime.hour,
        alarm.alarmTime.minute,
      ).add(Duration(days: daysToAdd));
    }

    return scheduled;
  }

  String _getRingtonePath(String ringtone) {
    switch (ringtone) {
      case 'Birds':
        return 'assets/audio/morning_birds.mp3';
      case 'Digital':
        return 'assets/audio/digital_alarm.mp3';
      default:
        return 'assets/audio/morning_birds.mp3';
    }
  }
}
