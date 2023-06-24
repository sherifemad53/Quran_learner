import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/aya_model.dart';

class SurahProvider {
  List<AyaModel>? ayas;

  Future<void> init() async {
    final String response = await rootBundle.loadString('assets/quran.json');
    ayas = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
  }

  List<AyaModel> getSurahByName(String surahNameArabic, String surahNo) {
    return ayas!
        .where((element) => element.surahNameArabic == surahNameArabic)
        .toList();
  }

  List<AyaModel> getSurahBySurahNo(String surahNo) {
    return ayas!.where((element) => element.surahNo == surahNo).toList();
  }

  List<AyaModel> getSurahBySurahNameAndSurahNo(
      String surahNameArabic, String surahNo) {
    return ayas!
        .where((element) =>
            element.surahNameArabic == surahNameArabic ||
            element.surahNo == surahNo)
        .toList();
  }
}
