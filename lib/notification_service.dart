import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // iOS and macOS initialization settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Linux initialization settings
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );

    // Combine settings for all platforms
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    final iOSDetails = DarwinNotificationDetails(
      sound: 'default',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> updateNotification(
      int id, String title, String body, DateTime newScheduledTime) async {
    await cancelNotification(id); // Cancel the existing notification
    await scheduleNotification(
        id, title, body, newScheduledTime); // Reschedule with new time
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle notification received in foreground
  }

  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    // Handle notification response (tap action, etc.)
  }
}
