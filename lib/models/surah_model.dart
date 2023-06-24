// To parse this JSON data, do
//
//     final surahModel = surahModelFromJson(jsonString);

import 'dart:convert';

SurahModel surahModelFromJson(String str) =>
    SurahModel.fromJson(json.decode(str));

String surahModelToJson(SurahModel data) => json.encode(data.toJson());

class SurahModel {
  int? id;
  String? surahNameArabic;
  String? surahNameEnglish;
  String? surahMeaning;
  String? classification;
  String? totalVerses;

  SurahModel({
    required this.id,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.surahMeaning,
    required this.classification,
    required this.totalVerses,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
        id: json["id"],
        surahNameArabic: json["surahNameArabic"],
        surahNameEnglish: json["SurahNameEnglish"],
        surahMeaning: json["SurahMeaning"],
        classification: json["Classification"],
        totalVerses: json["total_verses"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "surahNameArabic": surahNameArabic,
        "SurahNameEnglish": surahNameEnglish,
        "SurahMeaning": surahMeaning,
        "Classification": classification,
        "total_verses": totalVerses,
      };
}
