import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/aya_model.dart';

class SurahProvider {
  Future<List<AyaModel>> quranReadJson(
      String surahNameArabic, String surahNo) async {
    final String response =
        await rootBundle.loadString('assets/quran.json');
    List<AyaModel> quran = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
    var x = quran
        .where((element) => element.surahNameArabic == surahNameArabic)
        .toList();
    return x;
  }
}
