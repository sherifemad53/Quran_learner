// To parse this JSON data, do
//
//     final juzModel = juzModelFromJson(jsonString);

import 'dart:convert';

List<JuzModel> juzModelFromJson(String str) => List<JuzModel>.from(json.decode(str).map((x) => JuzModel.fromJson(x)));

String juzModelToJson(List<JuzModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JuzModel {
    int juz;
    String juzNameArabic;
    String juzNameEnglish;

    JuzModel({
        required this.juz,
        required this.juzNameArabic,
        required this.juzNameEnglish,
    });

    factory JuzModel.fromJson(Map<String, dynamic> json) => JuzModel(
        juz: json["Juz"],
        juzNameArabic: json["JuzNameArabic"],
        juzNameEnglish: json["JuzNameEnglish"],
    );

    Map<String, dynamic> toJson() => {
        "Juz": juz,
        "JuzNameArabic": juzNameArabic,
        "JuzNameEnglish": juzNameEnglish,
    };
}
