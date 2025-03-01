import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //INITIALIZED
  Future<void> initNotification() async {
    if (_isInitialized) return; //prevent re-initialization

    //prepare android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    //prepare settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    //initialize
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  // REQUEST PERMISSIONS
  Future<void> requestPermissions() async {
    if (!_isInitialized) {
      await initNotification(); // Ensure initialized before requesting
    }

    // Request iOS permissions specifically (already handled in init for iOS if set to true)
    if (Platform.isIOS) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      // For Android, we can use permission_handler package for more granular control if needed
      // For basic notifications, the plugin might handle runtime permissions automatically in some cases.
      // However, for explicit control and future-proofing, consider using permission_handler.
      // Example using permission_handler (you'll need to add it to pubspec.yaml):
      var status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.notification.request();
      }
      if (status.isGranted) {
        print('Notification permissions granted on Android');
      } else {
        print('Notification permissions denied on Android');
      }
    }
  }

  //NOTIFICATION DETAILS SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notification Channel',
        importance: Importance.max,
        priority: Priority.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  //ON NOTI TAP
}
