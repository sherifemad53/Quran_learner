import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Future<void> init() async {}

  bool? _isDark = false;
  bool? get getTheme => _isDark;

  String? _surahViewMode = 'Recitation';
  String? get getSurahViewMode => _surahViewMode;

  bool? _isEnglishTransEnabled = false;
  bool? get getIsEnglishTransEnabled => _isEnglishTransEnabled;

  void updateTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AppTheme', isDark);

    _isDark = prefs.getBool('AppTheme');
    notifyListeners();
  }

  void updateIsEnglishViewEnableed(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('EnglishView', isDark);

    _isEnglishTransEnabled = prefs.getBool('EnglishView');
    notifyListeners();
  }

  void updateSurahViewMode(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("SurahViewMode", mode);

    _surahViewMode = prefs.getString('SurahViewMode');
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
