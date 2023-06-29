import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '/models/tafser_model.dart';
import '../models/senstense_similarity_model.dart';

Future<List<SenstenceSimilarityModel>> similarVerseModelhApi(text) async {
  var uri = Uri.parse('https://omarelsayeed-test.hf.space/api/predict');
  var post = await http.post(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'data': [text]
    }),
  );
  try {
    if (post.statusCode == 200) {
      var x = (((json.decode(utf8.decode(post.bodyBytes))['data']) as List)
              .elementAt(0) as List)
          .map((element) => SenstenceSimilarityModel.fromJson(
              element as Map<String, dynamic>));
      return x.toList();
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      debugPrint(post.statusCode.toString());
    }
  } on Exception catch (e) {
    debugPrint("Error: $e");
  }
  return [];
}

Future<String> tafserReadJson(
    String? surahName, int? surahNum, int? ayaNum) async {
  final String response = await rootBundle.loadString('assets/tafser.json');
  var tasfirText = tafserModelFromJson(response);
  return tasfirText
      .firstWhere(
          (element) => (element.ayah == ayaNum && element.surah == surahNum))
      .tafseer;
}