// final quranFromJson = quranFromJsonFromJson(jsonString);

import 'dart:convert';

class QuranFromJson {
    QuranFromJson({
        required this.juzNameArabic,
        required this.surahNameArabic,
        required this.verusCount,
        required this.arabicText,
        required this.orignalArabicText,
    });

    final String juzNameArabic;
    final String surahNameArabic;
    final int verusCount;
    final List<String> arabicText;
    final List<String> orignalArabicText;

    factory QuranFromJson.fromRawJson(String str) => QuranFromJson.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory QuranFromJson.fromJson(Map<String, dynamic> json) => QuranFromJson(
        juzNameArabic: json["JuzNameArabic"],
        surahNameArabic: json["SurahNameArabic"],
        verusCount: json["VerusCount"],
        arabicText: List<String>.from(json["ArabicText"].map((x) => x)),
        orignalArabicText: List<String>.from(json["OrignalArabicText"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "JuzNameArabic": juzNameArabic,
        "SurahNameArabic": surahNameArabic,
        "VerusCount": verusCount,
        "ArabicText": List<dynamic>.from(arabicText.map((x) => x)),
        "OrignalArabicText": List<dynamic>.from(orignalArabicText.map((x) => x)),
    };
}
