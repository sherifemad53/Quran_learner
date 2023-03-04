import 'package:flutter/material.dart';

class TTextTheme {
  static TextTheme lightTextTheme = const TextTheme(
    displaySmall: TextStyle(fontSize: 20),
    displayMedium: TextStyle(fontSize: 20),
    displayLarge: TextStyle(fontSize: 20),
    headlineSmall: TextStyle(fontSize: 21),
    headlineMedium: TextStyle(fontSize: 25),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 18),
    bodyLarge: TextStyle(fontSize: 20),
    labelSmall: TextStyle(fontSize: 20),
    labelMedium: TextStyle(fontSize: 20),
    labelLarge: TextStyle(fontSize: 20),
    titleSmall: TextStyle(fontSize: 20),
    titleMedium: TextStyle(fontSize: 20),
    titleLarge: TextStyle(fontSize: 20),
  );
  static TextTheme darkTextTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 20),
    displayMedium: TextStyle(fontSize: 20),
    displaySmall: TextStyle(fontSize: 20),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(fontSize: 20),
    headlineSmall: TextStyle(fontSize: 20),
    bodySmall: TextStyle(fontSize: 16, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 22, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
    labelLarge: TextStyle(fontSize: 20),
    labelMedium: TextStyle(fontSize: 20),
    labelSmall: TextStyle(fontSize: 20),
    titleLarge: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 27),
    titleSmall: TextStyle(fontSize: 20),
  );
}
