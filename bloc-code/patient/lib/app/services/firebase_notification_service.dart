import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

// class FirebaseNotificationService {
//   FirebaseNotificationService._privateConstructor();
//   static final FirebaseNotificationService _instance = FirebaseNotificationService._privateConstructor();
//   static FirebaseNotificationService get instance => _instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future initialize() async {
//     await _firebaseMessaging.requestPermission();
//     final fMCToken = await _firebaseMessaging.getToken();

//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );

//     FirebaseMessaging.onMessage.listen(firebaseMessagingHandler);
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);
//   }

//   Future<String> getToken() async {
//     return await _firebaseMessaging.getToken() ?? "";
//   }
// }

// // Firebase notification setup
// Future<void> firebaseMessagingHandler(RemoteMessage message) async {
//   Map<String, dynamic> firebasePayload = stringToMap(message.data["meta"]);
//   if (firebasePayload["criteria"] != "appointment" &&
//       !firebasePayload["title"].toLowerCase().contains(
//             "Calling".toLowerCase(),
//           )) {
//     showNotification(
//       message: message,
//     );
//   }
// }

Future<void> showNotification({required RemoteMessage message}) async {
  log("Notification Showing log");
  print("Notification Showing print");
  var localNotification = FlutterLocalNotificationsPlugin();

  localNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await localNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await localNotification.initialize(notificationInitializationSettings);

  if (message.notification?.title != null ||
      message.notification?.body != null) {
    await localNotification.show(
      message.notification.hashCode,
      message.notification?.title ?? 'Test',
      message.notification?.body ?? 'Hello World!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationId,
          androidNotificationChannel.name,
          showWhen: false,
          priority: Priority.high,
          importance: Importance.max,
          channelDescription: androidNotificationChannel.description,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
        ),
      ),
    );
  }
}

// Android notification configuration
const androidNotificationId = 'high';
const androidNotificationName = 'High Importance Notifications';
const androidNotificationDescription =
    'This channel is used for important notifications.';
const androidInitialization = AndroidInitializationSettings(
  'ic_launcher',
);
const androidNotificationChannel = AndroidNotificationChannel(
  androidNotificationId,
  androidNotificationName,
  enableLights: true,
  enableVibration: true,
  playSound: true,
  // sound: RawResourceAndroidNotificationSound('simple'),
  importance: Importance.max,
  description: androidNotificationDescription,
);

// Notification settings
const notificationInitializationSettings = InitializationSettings(
    android: androidInitialization, iOS: iosNotificationInitialization);
var platform = Platform.isAndroid;

// iOS notification configuration
const iosNotificationInitialization = DarwinInitializationSettings();

// local notification config
Future<void> setScheduledNotification({
  required String title,
  required String body,
  required TZDateTime scheduledTime,
}) async {
  var localNotification = FlutterLocalNotificationsPlugin();

  localNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await localNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  await localNotification.initialize(notificationInitializationSettings);
  tz.initializeTimeZones();

  await localNotification.zonedSchedule(
    5,
    title,
    body,
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotificationId,
        androidNotificationChannel.name,
        showWhen: false,
        priority: Priority.high,
        importance: Importance.max,
        channelDescription: androidNotificationChannel.description,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentSound: true,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.alarmClock,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
