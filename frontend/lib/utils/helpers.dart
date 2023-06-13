import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/snackbars.dart';

import '../firebase_options.dart';
import '../providers/auth_provider.dart';

void handleIfNotLoggedIn(Auth? auth) {
  if (auth == null) throw Exception('User is not logged in.');
  if (!auth.isUserLoggedIn) throw Exception('User is not logged in.');
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void handleFirebaseForegroundMessages(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showForegroundMessageSnackBar(context, message.notification?.body ?? '');
    }
  });
}

void initFirebaseCloudMessaging() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('FCM token: $fcmToken');
}
