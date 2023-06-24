import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/aya_model.dart';

class AyaProvider extends ChangeNotifier {

  void init(){
    
  }
  
  Future<AyaModel> getAyaBySurahNo(String surahNameArabic, String ayaNo) async {
    final String response = await rootBundle.loadString('assets/quran.json');
    List<AyaModel> quran = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
    var x = quran.firstWhere((element) =>
        element.surahNameArabic == surahNameArabic && element.ayahNo == ayaNo);
    return x;
  }

  Future<AyaModel> getAyaBySurahName(String surahNameArabic, String ayaNo) async {
    final String response = await rootBundle.loadString('assets/quran.json');
    List<AyaModel> quran = List<AyaModel>.from(
        (json.decode(response)).map((element) => AyaModel.fromJson(element)));
    var x = quran.firstWhere((element) =>
        element.surahNameArabic == surahNameArabic && element.ayahNo == ayaNo);
    return x;
  }
}
