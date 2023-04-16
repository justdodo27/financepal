import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeManager() {
    _getThemeAtInit();
  }

  _getThemeAtInit() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkSaved = prefs.getBool("darkMode") ?? true;
    if (isDarkSaved) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.dark;

  bool get isDark => themeMode == ThemeMode.dark;

  void _saveThemeInMemory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDark);
  }

  void toggleTheme() {
    themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveThemeInMemory();
  }
}
