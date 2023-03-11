import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:quran_leaner/screens/ahadith/ahadith_model.dart';
import 'package:http/http.dart' as http;

Future<List<AhadithModel>> similarAhadithApi(text) async {
  var uri = Uri.parse(
      'https://anzhir2011-a7ades-similarity-quran-v2.hf.space/api/predict');
  var post = await http.post(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'data': ['الحمدلله رب العالمين']
    }),
    //encoding: Encoding.getByName('utf-8'),
  );
  try {
    if (post.statusCode == 200) {
      //var x = utf8.decode(post.bodyBytes);
      var x = (((json.decode(utf8.decode(post.bodyBytes))['data']) as List)
              .elementAt(0) as List)
          .map((e) => AhadithModel.fromJson(e as Map<String, dynamic>));

      return x.toList();
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      debugPrint(post.statusCode.toString());
    }
  } on Exception catch (e) {
    debugPrint("Error: $e");
  }
  return [];
}
