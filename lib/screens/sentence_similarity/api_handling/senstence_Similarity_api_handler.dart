import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:quran_leaner/models/tafser_model.dart';
import '../../../models/senstenseSimilarity_model.dart';

// Future<Datum> tpgetData(text) async {
//   debugPrint("loaded again");
//   SentenceSimilarityModel jz;
//   var uri = Uri.parse(
//       'https://anzhir2011-sentencesimilarity-quran-v2.hf.space/api/predict');
//   // var uri = Uri.parse('https://anzhir2011-test.hf.space/api/predict');
//   var post = await http.post(
//     uri,
//     headers: {
//       HttpHeaders.authorizationHeader: "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",
//       HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
//       HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, List<String>>{
//       'data': [text]
//     }),
//     //encoding: Encoding.getByName('utf-8'),
//   );
//   try {
//     if (post.statusCode == 200) {
//       // debugPrint(utf8.decode(post.bodyBytes));
//       jz = SentenceSimilarityModelFromJson(utf8.decode(post.bodyBytes));
//       return jz.data!.elementAt(0);
//     } else if (post.statusCode >= 400 && post.statusCode <= 499) {
//       debugPrint(post.statusCode.toString());
//     }
//   } on Exception catch (e) {
//     debugPrint("Error: $e");
//   }
//   return Datum();
// }

Future<List<SenstenceSimilarityModel>> similarVerseModelhApi(text) async {
  //debugPrint("loaded again");
  var uri = Uri.parse('https://anzhir2011-test.hf.space/api/predict');
  var post = await http.post(
    uri,
    headers: {
      // HttpHeaders.authorizationHeader: "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",
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, List<String>>{
      'data': [text]
    }),
  );
  try {
    if (post.statusCode == 200) {
      //debugPrint(utf8.decode(post.bodyBytes));
      var x = (((json.decode(utf8.decode(post.bodyBytes))['data']) as List)
              .elementAt(0) as List)
          .map((e) =>
              SenstenceSimilarityModel.fromJson(e as Map<String, dynamic>));

      return x.toList();
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      debugPrint(post.statusCode.toString());
    }
  } on Exception catch (e) {
    debugPrint("Error: $e");
  }
  return [];
}

Future<String> tafseReadJson(
    String? surahName, int? surahNum, int? ayaNum) async {
  final String response = await rootBundle.loadString('assets/tafser.json');
  // final List<TafserModel> data = (await json.decode(response) as List)
  //     .map((e) => TafserModel.fromJson(e)) as List<TafserModel>;
  // print(data.elementAt(0).surah);
  var tasfirText = tafserModelFromJson(response);
  return tasfirText
      .firstWhere(
          (element) => (element.ayah == ayaNum && element.surah == surahNum))
      .tafseer;
}
