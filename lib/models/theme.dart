import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      surfaceVariant: Colors.white,
      primary: Colors.black,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade200,
      surfaceTint: Colors.white,
      errorContainer: Colors.white,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 0, 8, 100),
      surfaceVariant: const Color.fromARGB(255, 0, 10, 120),
      primary: Colors.white,
      secondary: Colors.grey.shade500,
      tertiary: const Color.fromARGB(255, 17, 17, 17),
      surfaceTint: const Color.fromARGB(255, 63, 63, 63),
      errorContainer: Colors.grey.shade900,
    ));
