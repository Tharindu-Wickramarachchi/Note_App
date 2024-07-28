import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.black,
      secondary: Colors.grey.shade700,
      tertiary: Colors.grey.shade200,
      surfaceTint: Colors.white,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Color.fromARGB(255, 0, 20, 80),
      primary: Colors.white,
      secondary: Colors.grey.shade500,
      tertiary: const Color.fromARGB(255, 17, 17, 17),
      surfaceTint: Colors.grey.shade900,
    ));
