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
    AndroidNotificationDetails('channelId', 'channelName',
        channelDescription: 'channel description',
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


/*
✅ 작성 리마인드 알림
ㄴ 타이틀 : 공감책방
ㄴ 메시지 : 오늘의 감사일기를 작성할 시간이에요!
ㄴ 시간설정 O
ㄴ 하나라도 오늘 작성한 일기가 있으면 보내지 않는다.

✅ 멤버 새글 알림
ㄴ 타이틀 : {책방명}
ㄴ 메시지 : {멤버명}님의 감사일기를 확인해보세요!
 */