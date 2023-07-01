import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/surah_model.dart';
import '../models/juz_model.dart';

class QuranProvider {
  List<SurahModel> _surahs = [];
  List<JuzModel> _juzs = [];

  Future<void> init() async {
    String response = await rootBundle.loadString('assets/surahnames.json');
    _surahs = List<SurahModel>.from(
        (json.decode(response)).map((element) => SurahModel.fromJson(element)));

    response = await rootBundle.loadString('assets/juz_data.json');
    _juzs = List<JuzModel>.from(
        (json.decode(response)).map((element) => JuzModel.fromJson(element)));
  }

  List<JuzModel> getSearchedJuzModel(String? JuzNameArabic) {
    List<JuzModel> x = JuzNameArabic == null
        ? _juzs
        : _juzs.where((element) {
            return element.juzNameArabic.contains(JuzNameArabic);
          }).toList();
    return x;
  }

  List<SurahModel> getSearchedSurahModel(String? surahNameArabic) {
    List<SurahModel> x = surahNameArabic == null
        ? _surahs
        : _surahs.where((element) {
            return element.surahNameArabic!.contains(surahNameArabic);
          }).toList();
    return x;
  }

  List<SurahModel> getSurahModel() {
    return _surahs;
  }

  List<JuzModel> getJuzModel() {
    return _juzs;
  }
}
