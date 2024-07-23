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
      String title, String body, DateTime scheduledTime) async {
    // Convert DateTime to TZDateTime
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final androidDetails = AndroidNotificationDetails(
      'your_channel_id', // Replace with your actual channel ID
      'your_channel_name', // Replace with your actual channel name
      channelDescription:
          'your_channel_description', // Replace with your actual channel description
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
      0,
      title,
      body,
      tzDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
