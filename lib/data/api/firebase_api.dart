import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:santos_checker/data/helpers/server_helper.dart';
import 'package:sp_util/sp_util.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // // If you're going to use other Firebase services in the background, such as Firestore,
  // // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    debugPrint('Handling a background message ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Payload: ${message.data}');
  }

  // Future initLocalNotifications() async {
  //   const iOS = DarwinInitializationSettings();
  //   const android = AndroidInitializationSettings('@drawable/ic_launcher');
  //   const settings = InitializationSettings(android: android, iOS: iOS);

  //   await _localNotifications.initialize(
  //     settings,
  //     onDidReceiveNotificationResponse:
  //         (NotificationResponse notificationResponse) {
  //       final message =
  //           RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
  //       switch (notificationResponse.notificationResponseType) {
  //         case NotificationResponseType.selectedNotification:
  //           selectNotificationStream.add(notificationResponse.payload);
  //           handleMessage(message);
  //           break;
  //         case NotificationResponseType.selectedNotificationAction:
  //           if (notificationResponse.actionId == "id_3") { //navigationActionId
  //             selectNotificationStream.add(notificationResponse.payload);
  //             handleMessage(message);
  //           }
  //           break;
  //       }
  //     },
  //   );

  //   final platform = _localNotifications.resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>();
  //   await platform?.createNotificationChannel(_androidChannel);
  // }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      debugPrint("ForegroundNotification: ${notification.body}");
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text("${notification.title}, ${notification.body}"),
      //   backgroundColor: Colors.green,
      // ));
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint("Firebase Token put: $fCMToken");
    initPushNotifications();
  }
}
