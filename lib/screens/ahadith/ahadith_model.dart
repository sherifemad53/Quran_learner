// // To parse this JSON data, do
// //
// //     final ahadithModel = ahadithModelFromJson(jsonString);

import 'dart:convert';

class AhadithModel {
  AhadithModel({
    required this.similarSentence,
    required this.similarityScore,
  });

  final String similarSentence;
  final double similarityScore;

  factory AhadithModel.fromJson(Map<String, dynamic> json) => AhadithModel(
        similarSentence: json["similar_sentence"],
        similarityScore: json["similarity_score"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "similar_sentence": similarSentence,
        "similarity_score": similarityScore,
      };
}
