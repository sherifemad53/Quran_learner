import 'package:flutter/material.dart';

class TTextTheme {
  static TextTheme lightTextTheme = const TextTheme(
    displaySmall: TextStyle(fontSize: 20),
    displayMedium: TextStyle(fontSize: 20),
    displayLarge: TextStyle(fontSize: 20),
    headlineSmall:
        TextStyle(fontSize: 20, fontFamily: 'Roboto', color: Colors.black),
    headlineMedium:
        TextStyle(fontSize: 24, fontFamily: 'Roboto', color: Colors.black),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
      color: Colors.black,
    ),
    bodySmall: TextStyle(fontSize: 16, color: Colors.black54),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 22, color: Colors.black),
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
    headlineSmall:
        TextStyle(fontSize: 20, fontFamily: 'Roboto', color: Colors.white),
    headlineMedium:
        TextStyle(fontSize: 24, fontFamily: 'Roboto', color: Colors.white),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    bodyLarge: TextStyle(fontSize: 22, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
    bodySmall: TextStyle(fontSize: 16, color: Colors.white),
    labelLarge: TextStyle(fontSize: 20),
    labelMedium: TextStyle(fontSize: 20),
    labelSmall: TextStyle(fontSize: 20),
    titleLarge: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 27),
    titleSmall: TextStyle(fontSize: 20),
  );
}
