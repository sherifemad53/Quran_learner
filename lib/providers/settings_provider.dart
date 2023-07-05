import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _isEnglishTransEnabled = prefs.getBool('EnglishView');
    _isEnglishTransEnabled ??= false;

    _surahViewMode = prefs.getString('SurahViewMode');
    _surahViewMode ??= 'Recitation';

    _surahViewFontSize = prefs.getDouble('FontSize');
    _surahViewFontSize ??= 24;
  }

  bool? _isDark = false;
  bool? get getTheme => _isDark;

  String? _surahViewMode = 'Recitation';
  String? get getSurahViewMode => _surahViewMode;

  bool? _isEnglishTransEnabled = false;
  bool? get getIsEnglishTransEnabled => _isEnglishTransEnabled;

  double? _surahViewFontSize = 26;
  double? get getSurahViewFontSize => _surahViewFontSize;

  void updateSurahViewFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('FontSize', fontSize);

    _surahViewFontSize = prefs.getDouble('FontSize');
    notifyListeners();
  }

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
