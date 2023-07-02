import 'dart:convert';

SpeechToTextModel speechToTextModelFromJson(String str) => SpeechToTextModel.fromJson(json.decode(str));

String speechToTextModelToJson(SpeechToTextModel data) => json.encode(data.toJson());

class SpeechToTextModel {
  SpeechToTextModel({
    this.data,
    this.isGenerating,
    this.duration,
    this.averageDuration,
  });

  List<String>? data;
  bool? isGenerating;
  double? duration;
  double? averageDuration;

  factory SpeechToTextModel.fromJson(Map<String, dynamic> json) => SpeechToTextModel(
        data: List<String>.from(json["data"].map((x) => x)),
        isGenerating: json["is_generating"],
        duration: json["duration"].toDouble(),
        averageDuration: json["average_duration"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x)),
        "is_generating": isGenerating,
        "duration": duration,
        "average_duration": averageDuration,
      };
}
