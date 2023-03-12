//     final SenstenceSimilarityModel = SenstenceSimilarityModelFromJson(jsonString);

import 'dart:convert';

List<SenstenceSimilarityModel> senstenceSimilarityModelFromJson(String str) =>
    List<SenstenceSimilarityModel>.from(
        json.decode(str).map((x) => SenstenceSimilarityModel.fromJson(x)));

String senstenceSimilarityModelToJson(List<SenstenceSimilarityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SenstenceSimilarityModel {
  SenstenceSimilarityModel({
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

  factory SenstenceSimilarityModel.fromJson(Map<String, dynamic> json) =>
      SenstenceSimilarityModel(
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
