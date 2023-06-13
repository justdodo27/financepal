import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

const lightColorScheme = ColorScheme.light(
  primary: Color(0xffededed),
  onPrimary: Color.fromARGB(255, 240, 240, 240),
  secondary: Color.fromARGB(255, 234, 234, 234),
  onSecondary: Color(0xffc3c3c3),
  background: Color.fromARGB(255, 240, 240, 240),
  onBackground: Color.fromARGB(255, 145, 145, 145),
  tertiary: Color.fromARGB(255, 149, 62, 255),
);

const darkColorScheme = ColorScheme.dark(
  primary: Color(0xff121212),
  onPrimary: Color(0xff1e1e1e),
  secondary: Color.fromARGB(255, 35, 35, 35),
  onSecondary: Color.fromARGB(255, 60, 60, 60),
  background: Color(0xff1e1e1e),
  onBackground: Color.fromARGB(255, 55, 55, 55),
  tertiary: Color(0xffbb86fc),
);

final List<Color> colors = [
  Colors.purple,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.indigo,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.green[800]!,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.orangeAccent,
  Colors.green,
  Colors.teal,
  Colors.amber,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.brown,
  Colors.grey,
];

Color getPieChartColor(int index) {
  return colors[index % colors.length];
}
