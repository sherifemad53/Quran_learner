import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'sentencesimilarity_json.dart';
//import 'package:dio/dio.dart' as dio;

Future<Datum> tpgetData(text) async {
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
      'data': ['الحمدلله رب العالمين']
    }),
    //encoding: Encoding.getByName('utf-8'),
  );
  if (post.statusCode == 200) {
    var jz = tpFromJson(utf8.decode(post.bodyBytes));
    return jz.data!.elementAt(0);
    // for (var d in data.confidences!) {
    //   print("${d.label} ,  ${d.confidence.toString()}");
    // }
  } else if (post.statusCode >= 400 && post.statusCode <= 499) {
    debugPrint(post.statusCode.toString());
  }
  return Datum();
}
