import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'sentence_similarity_model.dart';
//import 'package:dio/dio.dart' as dio;

Future<Datum> tpgetData(text) async {
  debugPrint("loaded again");
  SentenceSimilarityModel jz;
  var uri = Uri.parse(
      'https://anzhir2011-sentencesimilarity-quran-v2.hf.space/api/predict');
  var post = await http.post(
    uri,
    headers: {
      HttpHeaders.authorizationHeader: "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",
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'data': [text]
    }),
    //encoding: Encoding.getByName('utf-8'),
  );
  try {
    if (post.statusCode == 200) {
      jz = SentenceSimilarityModelFromJson(utf8.decode(post.bodyBytes));
      return jz.data!.elementAt(0);
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      debugPrint(post.statusCode.toString());
    }
  } on Exception catch (e) {
    debugPrint("Error: $e");
  }
  return Datum();
}
