import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quran_leaner/components/topicmodeling_json.dart';
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

// void _submit() async {
//   // call REST service and extract JSON body
//   var host = 'http://flaskmli.azurewebsites.net/nlp/sa/alldata=';
//   var response = await http.get(host+inputController.text);
//   var resp = response.body;
//   // extract JSON "results" array to a Map (dictionary)
//   // push it onto the new dataList array (list of Maps)
//   Map<String, dynamic> nlps = jsonDecode(resp);
//   List<dynamic> results = nlps['results'];
//   List<Map<String, dynamic>> dataList = [];
//   results.forEach((result) {
//     dataList.add(result);
//   });
//   // bit of hack here, add input text to _rawContentList
//   _rawContentList.insert(0,[dataList, inputController.text])
//   inputController.text = '';
//   // reset focus (clears keyboard on mobile devices)
//   FocusScope.of(context).requestFocus(FocusNode());
//   setState(() {});   // make GUI refresh from _rawContentList
// }