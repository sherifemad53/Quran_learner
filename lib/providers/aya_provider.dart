import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/aya_model.dart';

class AyaProvider extends ChangeNotifier {
  //TODO UNDERSTAND THIS CONFUISON JSON PROVIDES AYAS NOT SURAH SO how to get surah?
  //DOES SURAH is list of AYAMODEL?
  //DOES JUZ LIST OF AYAMDOEL

  Future<AyaModel> quranReadJson(String surahNameArabic, String ayaNo) async {
    final String response = await rootBundle.loadString('assets/quran.json');
    List<AyaModel> quran = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
    var x = quran.firstWhere((element) =>
        element.surahNameArabic == surahNameArabic && element.ayahNo == ayaNo);
    return x;
  }
}
