// To parse this JSON data, do
//
//     final tp = tpFromJson(jsonString);

import 'dart:convert';

Tp tpFromJson(String str) => Tp.fromJson(json.decode(str));

//String tpToJson(Tp data) => json.encode(data.toJson());

class Tp {
  Tp({
    this.data,
    this.isGenerating,
    this.duration,
    this.averageDuration,
  });

  List<Datum>? data;
  bool? isGenerating;
  double? duration;
  double? averageDuration;

  factory Tp.fromJson(Map<String, dynamic> json) => Tp(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        isGenerating: json["is_generating"],
        duration: json["duration"].toDouble(),
        averageDuration: json["average_duration"].toDouble(),
      );

  // Map<String, dynamic> toJson() => {
  //       "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  //       "is_generating": isGenerating,
  //       "duration": duration,
  //       "average_duration": averageDuration,
  //     };
}

class Datum {
  Datum({
    this.label,
    this.confidences,
  });

  String? label;
  List<Confidence>? confidences;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        label: json["label"],
        confidences: List<Confidence>.from(
            json["confidences"].map((x) => Confidence.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "label": label,
  //       "confidences": List<dynamic>.from(confidences!.map((x) => x.toJson())),
  //     };
}

class Confidence {
  Confidence({
    this.label,
    this.confidence,
  });

  String? label;
  double? confidence;

  factory Confidence.fromJson(Map<String, dynamic> json) => Confidence(
        label: json["label"],
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "confidence": confidence,
      };
}
