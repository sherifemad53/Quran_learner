import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/aya_model.dart';

class AyaProvider extends ChangeNotifier {
  Future<AyaModel> getAyaBySurahNameArabicAndSurahNo(
      String surahNameArabic, String ayaNo) async {
    final String response = await rootBundle.loadString('assets/quran.json');
    List<AyaModel> quran = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
    return quran.firstWhere((element) =>
        element.surahNameArabic == surahNameArabic && element.ayahNo == ayaNo);
  }
}
