import 'package:flutter/material.dart';
import 'package:note/models/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(themeData);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  // Load the theme from shared preferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  // Save the theme to shared preferences
  void _saveTheme(ThemeData themeData) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = themeData == darkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
