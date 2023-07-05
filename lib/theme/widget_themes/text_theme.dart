import 'package:flutter/material.dart';

class TTextTheme {
  static TextTheme lightTextTheme = const TextTheme(
    displaySmall: TextStyle(fontSize: 20),
    displayMedium: TextStyle(fontSize: 20),
    displayLarge: TextStyle(fontSize: 20),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontFamily: 'Roboto',
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontFamily: 'Roboto',
    ),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
    bodySmall: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 20),
    bodyLarge: TextStyle(fontSize: 22),
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
    bodyLarge: TextStyle(fontSize: 22, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
    bodySmall: TextStyle(fontSize: 14, color: Colors.white),
    labelLarge: TextStyle(fontSize: 20),
    labelMedium: TextStyle(fontSize: 20),
    labelSmall: TextStyle(fontSize: 20),
    titleLarge: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 27),
    titleSmall: TextStyle(fontSize: 20),
  );
}
