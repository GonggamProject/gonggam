import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("mipmap/ic_launcher");

    DarwinInitializationSettings iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() {
    FirebaseMessaging.instance.requestPermission(
      badge: true,
      alert: true,
      sound: true,
    );
  }

  static Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('gonggam', '공감일기 알람',
        channelDescription: '공감일기 알람',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1));

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  static void notificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          showNotification(message.notification!.title, message.notification!.body);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          showNotification(message.notification!.title, message.notification!.body);
        }
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        if (message.notification != null) {
          showNotification(message.notification!.title, message.notification!.body);
        }
      }
    });
  }
}