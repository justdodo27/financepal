import 'package:flutter/material.dart';
import 'package:frontend/providers/api_provider.dart';
import 'package:frontend/themes/theme_manager.dart';
import 'package:provider/provider.dart';

import 'pages/accounts/login_consumer.dart';
import 'themes/theme_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => BackendApi(),
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
