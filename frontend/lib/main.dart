import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/accounts/login_consumer.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/group_provider.dart';
import 'providers/payment_proof_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/recurring_payment_provider.dart';
import 'providers/statistics_provider.dart';
import 'themes/theme_constants.dart';
import 'themes/theme_manager.dart';
import 'utils/api/api_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message: ${message.notification!.body}');
}

void _firebaseMessagingForegroundHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

void _initFirebaseCloudMessaging() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _firebaseMessagingForegroundHandler();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log('FCM token: $fcmToken');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initFirebaseCloudMessaging();
  final apiService = ApiService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth(apiService)),
        ChangeNotifierProxyProvider<Auth, StatisticsProvider>(
          update: (context, auth, _) => StatisticsProvider(auth),
          create: (context) => StatisticsProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, CategoryProvider>(
          update: (context, auth, _) => CategoryProvider(auth),
          create: (context) => CategoryProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, PaymentProvider>(
          update: (context, auth, _) => PaymentProvider(auth),
          create: (context) => PaymentProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, RecurringPaymentProvider>(
          update: (context, auth, _) => RecurringPaymentProvider(auth),
          create: (context) => RecurringPaymentProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, PaymentProofProvider>(
          update: (context, auth, _) => PaymentProofProvider(auth),
          create: (context) => PaymentProofProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, GroupProvider>(
          update: (context, auth, _) => GroupProvider(auth),
          create: (context) => GroupProvider(null),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      builder: (context, child) {
        final themeManager = Provider.of<ThemeManager>(context);
        return MaterialApp(
          title: 'FinancePal',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: lightColorScheme.background,
            ),
            shadowColor: Colors.grey,
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            textTheme: textTheme.apply(
                bodyColor: Colors.black, displayColor: Colors.black),
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: darkColorScheme.background,
            ),
            brightness: Brightness.dark,
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: const Color(0xff121212),
            textTheme: textTheme.apply(
                bodyColor: Colors.white, displayColor: Colors.white),
            colorScheme: darkColorScheme,
          ),
          themeMode: themeManager.themeMode,
          debugShowCheckedModeBanner: false,
          home: const LoginConsumer(),
        );
      },
    );
  }
}
