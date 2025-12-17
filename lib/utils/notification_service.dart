import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // Initialize notifications
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, // Use default icon
      [
        NotificationChannel(
          channelKey: 'test_channel',
          channelName: 'Test Reminders',
          channelDescription: 'Reminders for upcoming DL tests',
          defaultColor: const Color(0xFF2E7D32),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: false,
        ),
      ],
    );

    // Request permissions
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Schedule a notification
  static Future<void> scheduleTestReminder(
    DateTime testDateTime,
    String testName,
  ) async {
    // Schedule 10 minutes before test
    DateTime scheduleTime = testDateTime.subtract(const Duration(minutes: 10));

    if (scheduleTime.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: testDateTime.hashCode, // unique ID
          channelKey: 'test_channel',
          title: 'Upcoming Driving Test',
          body: 'Your $testName starts in 10 minutes',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduleTime,
          preciseAlarm: true,
        ),
      );
    }
  }
}
