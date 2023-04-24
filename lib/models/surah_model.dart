// To parse this JSON data, do
//
//     final quranModel = quranModelFromJson(jsonString);

import 'package:quranic_tool_box/models/aya_model.dart';

class QuranModel extends AyaModel {
  QuranModel(
      {required super.srNo,
      required super.juz,
      required super.juzNameArabic,
      required super.juzNameEnglish,
      required super.surahNo,
      required super.surahNameArabic,
      required super.surahNameEnglish,
      required super.surahMeaning,
      required super.webLink,
      required super.classification,
      required super.ayahNo,
      required super.englishTranslation,
      required super.orignalArabicText,
      required super.arabicText,
      required super.arabicWordCount,
      required super.arabicLetterCount});
}
