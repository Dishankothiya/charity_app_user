// // // import 'dart:js';
// // import 'dart:math';

// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // class NotificationServices {
// //   FirebaseMessaging messaging = FirebaseMessaging.instance;

// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   void requestNotificationPermission() async {
// //     NotificationSettings settings = await messaging.requestPermission(
// //         alert: true,
// //         announcement: true,
// //         badge: true,
// //         carPlay: true,
// //         criticalAlert: true,
// //         provisional: true,
// //         sound: true);
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print("user granted permision");
// //     } else if (settings.authorizationStatus ==
// //         AuthorizationStatus.provisional) {
// //       print("user granted provisional permision");
// //     } else {
// //       print("user denied permision");
// //     }
// //   }

// //   void initLocalNotifications(
// //       BuildContext context, RemoteMessage Message) async {
// //     var androidInitializationSettings =
// //         const AndroidInitializationSettings('@mipmap-mdpi/launcher_icon.png');
// //     var iosInitializationSettings = const DarwinInitializationSettings();

// //     var initializationSettings = InitializationSettings(
// //         android: androidInitializationSettings, iOS: iosInitializationSettings);

// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //         onDidReceiveNotificationResponse: (payload) {});
// //   }

// //   void firebaseInit() {
// //     FirebaseMessaging.onMessage.listen((message) {
// //       if (kDebugMode) {
// //         print(message.notification!.title.toString());
// //         print(message.notification!.body.toString());
// //       }
// //       showNotification(message);
// //     });
// //   }

// //   Future<void> showNotification(RemoteMessage message) async {
// //     AndroidNotificationChannel channel = AndroidNotificationChannel(
// //         Random.secure().nextInt(100000).toString(),
// //         "High Importance Notification",
// //         importance: Importance.max);

// //     AndroidNotificationDetails androidNotificationDetails =
// //         AndroidNotificationDetails(
// //             channel.id.toString(), channel.name.toString(),
// //             channelDescription: "your chanle  description",
// //             importance: Importance.high,
// //             priority: Priority.high,
// //             ticker: 'ticker');

// //     const DarwinNotificationDetails darwinNotificationDetails =
// //         DarwinNotificationDetails(
// //             presentSound: true, presentBadge: true, presentAlert: true);

// //     NotificationDetails notificationDetails = NotificationDetails(
// //         android: androidNotificationDetails, iOS: darwinNotificationDetails);
// //     Future.delayed(Duration.zero, () {
// //       flutterLocalNotificationsPlugin.show(
// //           0,
// //           message.notification!.title.toString(),
// //           message.notification!.body.toString(),
// //           notificationDetails);
// //     });
// //   }

// //   Future<String> getDeviceToken() async {
// //     String? token = await messaging.getToken();
// //     return token!;
// //   }

// //   void isTokenRefresh() async {
// //     messaging.onTokenRefresh.listen((event) {
// //       event.toString();
// //       print("refresh");
// //     });
// //   }
// // }

// // second code

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:charity_donation/BottomBar/NotificationScreen/notificationScreen.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:awesome_notifications/awesome_notifications_web.dart';
// import 'package:charity_admin/BottomBar/HomePage/AdminNotification/adminNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AwesomeNotifictionServices {
  static Future<void> initialization() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'high_importance_channel',
              channelName: "Basic notification",
              channelDescription: 'Notification channel for basic tests',
              channelGroupKey: 'high_importance_channel',
              defaultColor: AppColor.appColor,
              ledColor: AppColor.whiteColor,
              importance: NotificationImportance.Max,
              channelShowBadge: true,
              onlyAlertOnce: true,
              playSound: true,
              criticalAlerts: true)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'high_importance_channel_group',
              channelGroupName: 'group 1')
        ],
        debug: true);
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);

    //
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethodMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      // MainApp.navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => notificationScreen(),));
      MaterialPageRoute(
        builder: (context) => notificationScreen(),
      );
    }
  }

  static Future<void> showNotification(
      {required final title,
      required final body,
      final String? summary,
      final Map<String, String>? payload,
      final ActionType actionType = ActionType.Default,
      final NotificationLayout notificationLayout = NotificationLayout.Default,
      final NotificationCategory? category,
      final String? bigPicture,
      final List<NotificationActionButton>? actionButtons,
      final bool scheduled = false,
      final int? interval}) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'high_importance_channel',
            title: title,
            body: body,
            actionType: actionType,
            notificationLayout: notificationLayout,
            summary: summary,
            category: category,
            payload: payload,
            bigPicture: bigPicture),
        actionButtons: actionButtons,
        schedule: scheduled
            ? NotificationInterval(
                interval: interval,
                timeZone:
                    await AwesomeNotifications().getLocalTimeZoneIdentifier(),
                preciseAlarm: true)
            : null);
  }
}
class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    // Request permission to receive push notifications
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();

    return token;
  }
}

