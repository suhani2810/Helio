import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
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

  Future<void> scheduleDailyMoodReminder() async {
    // Simplified: Show one now for confirmation in this task context
    await showNotification(
      id: 999,
      title: 'Mood Check-in',
      body: 'How are you feeling this morning? Log your mood now.',
    );
  }
}
