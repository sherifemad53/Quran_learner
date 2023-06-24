import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quranic_tool_box/models/surah_model.dart';

class QuranProvider {
  List<SurahModel> _surahs = [];

  Future<void> init() async {
    final String response =
        await rootBundle.loadString('assets/surahnames.json');
    _surahs = List<SurahModel>.from(
        (json.decode(response)).map((element) => SurahModel.fromJson(element)));
  }

  Future<List<SurahModel>> getSearchedSurahModel(
      String? surahNameArabic) async {
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
}
