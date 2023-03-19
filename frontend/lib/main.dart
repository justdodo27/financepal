import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home_page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final textTheme = TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.spaceGrotesk(
      fontSize: 18.0,
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      fontSize: 16.0,
    ),
    bodySmall: GoogleFonts.spaceGrotesk(
      fontSize: 14.0,
    ),
  );

  final lightColorScheme = const ColorScheme.light(
    primary: Colors.white,
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 106, 0, 255),
    background: Color(0xff6200ee),
    onBackground: Color.fromARGB(255, 0, 94, 255),
    tertiary: Color.fromARGB(255, 134, 178, 255),
  );

  final darkColorScheme = const ColorScheme.dark(
    primary: Color(0xff121212),
    onPrimary: Color(0xff1e1e1e),
    secondary: Color.fromARGB(255, 35, 35, 35),
    background: Color(0xff1e1e1e),
    onBackground: Color.fromARGB(255, 55, 55, 55),
    tertiary: Color(0xffbb86fc),
  );

  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
