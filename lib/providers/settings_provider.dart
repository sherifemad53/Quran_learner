import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Future<void> init() async {}

  final bool _isDark = false;
  bool get getTheme => _isDark;

  void updateTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AppTheme', isDark);
    print('i henaaa');
    notifyListeners();
  }

  // Future<bool?> getTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('AppTheme') == null) {
  //     prefs.setBool('AppTheme', false);
  //   }

  //   bool? temp = prefs.getBool('AppTheme');
  //   notifyListeners();
  //   return temp;
  // }
}
