import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '/models/tafser_model.dart';
import '../models/verse_similarity_model.dart';

Future<List<VersesSimilarityModel>> similarVerseModelhApi(text) async {
  // Define the API endpoint URL
  var uri = Uri.parse('https://omarelsayeed-test.hf.space/api/predict');

  // Make a POST request to the API
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
    // Check the response status code
    if (post.statusCode == 200) {
      // Parse the response and convert the data into a list of SenstenceSimilarityModel objects
      var x = (((json.decode(utf8.decode(post.bodyBytes))['data']) as List)
              .elementAt(0) as List)
          .map((element) =>
              VersesSimilarityModel.fromJson(element as Map<String, dynamic>));

      return x.toList();
    } else if (post.statusCode >= 400 && post.statusCode <= 499) {
      // Handle client errors (4xx)
      debugPrint(post.statusCode.toString());
    }
  } on Exception catch (e) {
    // Handle and print any exceptions that occur during the API call
    debugPrint("Error: $e");
  }

  // Return an empty list if there was an error or the response is not successful
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
