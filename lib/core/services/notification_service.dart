import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    try {
      final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback to UTC
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request exact alarm permission automatically on initialization
    await requestExactAlarmPermission();
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification click if needed
  }

  Future<bool> requestExactAlarmPermission() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestExactAlarmsPermission();
      return granted ?? false;
    }
    return false;
  }

  Future<void> scheduleExactAlarmNotification({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    // Request permission automatically if needed
    await requestExactAlarmPermission();

    // Convert local DateTime to timezone TZDateTime
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    print('[NotificationService] Scheduling exact alarm ID $id for scheduled time: $scheduledTime (TZ: $tzTime)');

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'helio_exact_alarms',
          'Exact Alarms',
          channelDescription: 'Time-critical exact alarms for Helio',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          ongoing: true,
          showWhen: true,
          usesChronometer: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('[NotificationService] Cancelled notification ID $id');
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const android = AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'General reminders for Helio',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _notifications.show(id, title, body, details);
  }

  // Task 9: Sleep reminder notification
  Future<void> scheduleSleepReminder() async {
    await showNotification(
      id: 998,
      title: 'Time to Rest 🌙',
      body: 'Wind down and prepare for a beautiful tomorrow. Set your Helio alarms!',
    );
  }

  // Task 9: Mood check-in reminder notification
  Future<void> scheduleDailyMoodReminder() async {
    await showNotification(
      id: 999,
      title: 'Mood Check-in',
      body: 'How are you feeling this morning? Log your mood now.',
    );
  }

  // Task 9: Alarm enabled confirmation notification
  Future<void> showAlarmEnabledConfirmation(DateTime alarmTime) async {
    final hour = alarmTime.hour % 12 == 0 ? 12 : alarmTime.hour % 12;
    final min = alarmTime.minute.toString().padLeft(2, '0');
    final period = alarmTime.hour >= 12 ? 'PM' : 'AM';
    await showNotification(
      id: 100,
      title: 'Alarm Enabled ⏰',
      body: 'Your alarm is scheduled for $hour:$min $period!',
    );
  }

  // Task 9: Missed alarm notification
  Future<void> showMissedAlarmNotification() async {
    await showNotification(
      id: 101,
      title: 'Missed Alarm 😴',
      body: 'You missed your wake-up alarm! Stay committed to your streak.',
    );
  }
}
