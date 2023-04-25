import 'dart:convert';

DecodeStt decodeSttFromJson(String str) => DecodeStt.fromJson(json.decode(str));

String decodeSttToJson(DecodeStt data) => json.encode(data.toJson());

class DecodeStt {
  DecodeStt({
    this.data,
    this.isGenerating,
    this.duration,
    this.averageDuration,
  });

  List<String>? data;
  bool? isGenerating;
  double? duration;
  double? averageDuration;

  factory DecodeStt.fromJson(Map<String, dynamic> json) => DecodeStt(
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
