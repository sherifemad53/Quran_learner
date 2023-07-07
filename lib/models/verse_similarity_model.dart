//     final VersesSimilarityModel = VersesSimilarityModelFromJson(jsonString);

import 'dart:convert';

List<VersesSimilarityModel> versesSimilarityModelFromJson(String str) =>
    List<VersesSimilarityModel>.from(
        json.decode(str).map((x) => VersesSimilarityModel.fromJson(x)));

String versesSimilarityModelToJson(List<VersesSimilarityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VersesSimilarityModel {
  VersesSimilarityModel({
    required this.similarSentence,
    required this.similarityScore,
    required this.surahName,
    required this.ayahNo,
    required this.surahNumber,
  });

  final String similarSentence;
  final double similarityScore;
  final String surahName;
  final int ayahNo;
  final int surahNumber;

  factory VersesSimilarityModel.fromJson(Map<String, dynamic> json) =>
      VersesSimilarityModel(
        similarSentence: json["similar_sentence"],
        similarityScore: json["similarity_score"]?.toDouble(),
        surahName: json["surahName"],
        ayahNo: json["AyahNo"],
        surahNumber: json["SurahNumber"],
      );

  Map<String, dynamic> toJson() => {
        "similar_sentence": similarSentence,
        "similarity_score": similarityScore,
        "surahName": surahName,
        "AyahNo": ayahNo,
        "SurahNumber": surahNumber,
      };
}
