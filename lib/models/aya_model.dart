// To parse this JSON data, do
//
//     final AyaModel = AyaModelFromJson(jsonString);

// AyaModel AyaModelFromJson(String str) => AyaModel.fromJson(json.decode(str));

// String AyaModelToJson(AyaModel data) => json.encode(data.toJson());

class AyaModel {
  AyaModel({
    required this.srNo,
    required this.juz,
    required this.juzNameArabic,
    required this.juzNameEnglish,
    required this.surahNo,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.surahMeaning,
    required this.webLink,
    required this.classification,
    required this.ayahNo,
    required this.englishTranslation,
    required this.orignalArabicText,
    required this.arabicText,
    required this.arabicWordCount,
    required this.arabicLetterCount,
    isVisable,
    isRecited,
    isMemorized,
    isPressed,
  });

  final String srNo;
  final String juz;
  final String juzNameArabic;
  final String juzNameEnglish;
  final String surahNo;
  final String surahNameArabic;
  final String surahNameEnglish;
  final String surahMeaning;
  final String webLink;
  final String classification;
  final String ayahNo;
  final String englishTranslation;
  final String orignalArabicText;
  final String arabicText;
  final String arabicWordCount;
  final String arabicLetterCount;
  bool isVisable = true;
  bool isRecited = false;
  bool isMemorized = false;
  bool isPressed = false;

  factory AyaModel.fromJson(Map<String, dynamic> json) => AyaModel(
        srNo: json["SrNo"],
        juz: json["Juz"],
        juzNameArabic: json["JuzNameArabic"],
        juzNameEnglish: json["JuzNameEnglish"],
        surahNo: json["SurahNo"],
        surahNameArabic: json["SurahNameArabic"],
        surahNameEnglish: json["SurahNameEnglish"],
        surahMeaning: json["SurahMeaning"],
        webLink: json["WebLink"],
        classification: json["Classification"],
        ayahNo: json["AyahNo"],
        englishTranslation: json["EnglishTranslation"],
        orignalArabicText: json["OrignalArabicText"],
        arabicText: json["ArabicText"],
        arabicWordCount: json["ArabicWordCount"],
        arabicLetterCount: json["ArabicLetterCount"],
      );

  Map<String, dynamic> toJson() => {
        "SrNo": srNo,
        "Juz": juz,
        "JuzNameArabic": juzNameArabic,
        "JuzNameEnglish": juzNameEnglish,
        "SurahNo": surahNo,
        "SurahNameArabic": surahNameArabic,
        "SurahNameEnglish": surahNameEnglish,
        "SurahMeaning": surahMeaning,
        "WebLink": webLink,
        "Classification": classification,
        "AyahNo": ayahNo,
        "EnglishTranslation": englishTranslation,
        "OrignalArabicText": orignalArabicText,
        "ArabicText": arabicText,
        "ArabicWordCount": arabicWordCount,
        "ArabicLetterCount": arabicLetterCount,
      };
}
