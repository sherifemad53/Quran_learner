import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<AyaModel>> getSurahBySurahNameAndSurahNo(
      String surahNameArabic, String surahNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? temp = prefs.getStringList(surahNameArabic);
    if (temp == null) {
      return ayas!
          .where((element) =>
              element.surahNameArabic == surahNameArabic ||
              element.surahNo == surahNo)
          .toList();
    } else {
      return temp.map((e) => AyaModel.fromJson(jsonDecode(e))).toList();
    }
  }
}
