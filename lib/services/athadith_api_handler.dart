import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ahadith_model.dart';

Future<List<AhadithModel>> similarAhadithApi(text) async {
  var uri = Uri.parse(
      'https://omarelsayeed-a7ades-similarity-quran-v2.hf.space/api/predict');
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
      List<AhadithModel> temp =
          (((json.decode(utf8.decode(post.bodyBytes))['data']) as List)
                  .elementAt(0) as List)
              .map((element) =>
                  AhadithModel.fromJson(element as Map<String, dynamic>))
              .toList();

      return temp;
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      debugPrint(post.statusCode.toString());
    }
  } catch (error) {
    debugPrint("Error: $error");
  }
  return [];
}
