// To parse this JSON data, do
//
//     final tafserModel = tafserModelFromJson(jsonString);

import 'dart:convert';

List<TafserModel> tafserModelFromJson(String str) => List<TafserModel>.from(json.decode(str).map((x) => TafserModel.fromJson(x)));

String tafserModelToJson(List<TafserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TafserModel {
    TafserModel({
        required this.tafseer,
        required this.surah,
        required this.ayah,
    });

    final String tafseer;
    final int surah;
    final int ayah;

    factory TafserModel.fromJson(Map<String, dynamic> json) => TafserModel(
        tafseer: json["tafseer"],
        surah: json["surah"],
        ayah: json["ayah"],
    );

    Map<String, dynamic> toJson() => {
        "tafseer": tafseer,
        "surah": surah,
        "ayah": ayah,
    };
}
