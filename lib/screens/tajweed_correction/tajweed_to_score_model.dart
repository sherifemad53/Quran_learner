// To parse this JSON data, do
//
//     final TajweedToScoreModel = TajweedToScoreModelFromJson(jsonString);

import 'dart:convert';

TajweedToScoreModel tajweedToScoreModelFromJson(String str) =>
    TajweedToScoreModel.fromJson(json.decode(str));

class TajweedToScoreModel {
  List<Data> data;
  bool isGenerating;
  double duration;
  double averageDuration;

  TajweedToScoreModel({
    required this.data,
    required this.isGenerating,
    required this.duration,
    required this.averageDuration,
  });

  factory TajweedToScoreModel.fromJson(Map<String, dynamic> json) =>
      TajweedToScoreModel(
        data: dataFromJson(
            List<String>.from(json["data"].map((x) => x)).elementAt(0)),
        isGenerating: json["is_generating"],
        duration: json["duration"]?.toDouble(),
        averageDuration: json["average_duration"]?.toDouble(),
      );
}

List<Data> dataFromJson(String str) => List<Data>.from(
    json.decode(str.replaceAll("'", '"')).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  double score;
  String label;

  Data({
    required this.score,
    required this.label,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        score: json["score"]?.toDouble(),
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "label": label,
      };
}
