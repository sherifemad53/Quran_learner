// To parse this JSON data, do
//
//     final JuzModel = JuzModelFromJson(jsonString);

import 'dart:convert';

JuzModel juzModelFromJson(String str) =>
    JuzModel.fromJson(json.decode(str));

String juzModelToJson(JuzModel data) => json.encode(data.toJson());

class JuzModel {
  int? id;
  String? juzNameArabic;
  String? juzNameEnglish;
  String? totalVerses;

  JuzModel({
    required this.id,
    required this.juzNameArabic,
    required this.juzNameEnglish,
    required this.totalVerses,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) => JuzModel(
        id: json["id"],
        juzNameArabic: json["juzNameArabic"],
        juzNameEnglish: json["juzNameEnglish"],
        totalVerses: json["total_verses"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "juzNameArabic": juzNameArabic,
        "juzNameEnglish": juzNameEnglish,
        "total_verses": totalVerses,
      };
}
