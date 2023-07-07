import 'package:flutter/material.dart';
import '/theme/widget_themes/text_theme.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
    useMaterial3: true,
    backgroundColor: const Color.fromARGB(255, 187, 185, 169),
    //backgroundColor: kBackgroundColor,
    // bottomNavigationBarTheme:
    //     const BottomNavigationBarThemeData(backgroundColor: Colors.white12),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.black)),
    textTheme: TTextTheme.lightTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    //primaryColor: Colors.black12,
    // appBarTheme: const AppBarTheme(color: Colors.purple, elevation: 0),
    useMaterial3: true,
    //backgroundColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.all(10),
      fillColor: Colors.amber,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.black)),
    textTheme: TTextTheme.darkTextTheme,
  );
}
