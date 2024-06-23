// import 'package:awesome_notifications/awesome_notifications_web.dart';
// import 'package:charity_donation/Config/notificationservices.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:charity_donation/BottomBar/NotificationScreen/notificationScreen.dart';
import 'package:charity_donation/BottomBar/SavedScreen/savedScreen.dart';
import 'package:charity_donation/Config/notificationservices.dart';
import 'package:charity_donation/MyHomePage/myHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future multipleragistration() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic("all_users");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  multipleragistration();
  await AwesomeNotifictionServices.initialization();
  // FirebaseMessaging.onBackgroundMessage((message) {
  //   return _firebaseMessagingBackgroundHandler(message);
  // });

  runApp(
      // DevicePreview(
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      MyApp());
}

// Stream<QuerySnapshot> getSubcollectionStream() {
//   // Get a reference to the parent document
//   DocumentReference parentDocumentRef =
//       FirebaseFirestore.instance.collection('admin').doc();

//   // Return a stream of the subcollection
//   return parentDocumentRef
//       .collection('adminNotification')
//       .orderBy("NotificationTime", descending: true)
//       .snapshots();
// }
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'DO2vQR6ksZeCiLRggEZTMkEPeLq1',
      title: message.notification?.title ?? 'hello',
      body: message.notification?.body ?? 'how are you',
    ),
  );
  // StreamBuilder(
  //     stream: getSubcollectionStream(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center();
  //       }
  //       AwesomeNotifictionServices.showNotification(
  //           title: snapshot.data, body: snapshot.data);
  //       return Column(
  //         children: [Text("${title["AdminNotification "]}"), Text("$body")],
  //       );
  //     });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      home: myHomePage(),
      // home:NotificationReceiver()
    );
  }
}
