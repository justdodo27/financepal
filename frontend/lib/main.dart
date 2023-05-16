import 'package:flutter/material.dart';
import 'package:frontend/providers/recurring_payment_provider.dart';
import 'package:frontend/themes/theme_manager.dart';
import 'package:provider/provider.dart';

import 'pages/accounts/login_consumer.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/payment_provider.dart';
import 'themes/theme_constants.dart';
import 'utils/api/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth(apiService)),
        ChangeNotifierProxyProvider<Auth, CategoryProvider>(
          update: (context, auth, previousCategories) => CategoryProvider(auth),
          create: (context) => CategoryProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, PaymentProvider>(
          update: (context, auth, previousCategories) => PaymentProvider(auth),
          create: (context) => PaymentProvider(null),
        ),
        ChangeNotifierProxyProvider<Auth, RecurringPaymentProvider>(
          update: (context, auth, previousCategories) =>
              RecurringPaymentProvider(auth),
          create: (context) => RecurringPaymentProvider(null),
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
            splashColor: Colors.blue,
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            textTheme: textTheme.apply(
                bodyColor: Colors.black, displayColor: Colors.black),
            colorScheme: lightColorScheme,
            appBarTheme: AppBarTheme(
              backgroundColor: lightColorScheme.background,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: const Color(0xff121212),
            textTheme: textTheme.apply(
                bodyColor: Colors.white, displayColor: Colors.white),
            colorScheme: darkColorScheme,
            appBarTheme: AppBarTheme(
              backgroundColor: darkColorScheme.background,
            ),
          ),
          themeMode: themeManager.themeMode,
          debugShowCheckedModeBanner: false,
          home: const LoginConsumer(),
        );
      },
    );
  }
}
