import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'string_similarity.dart';
import 'decodeSTT.dart';

import '../../models/user_model.dart' as model;

class SpeechToText {
  SpeechToText._();
  static final instance = SpeechToText._();

  String text = '';
  final _record = Record();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> _speechToText(String? filename, model.User? user) async {
    Stopwatch stopwatch = Stopwatch()..start();
    var uri =
        Uri.parse('https://omarelsayeed-quran-recitation.hf.space/run/predict');
    var response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'data': ['${user!.uid}/$filename']
      }),
    );
    try {
      if (response.statusCode == 200) {
        text = decodeSttFromJson(utf8.decode(response.bodyBytes))
            .data!
            .elementAt(0);
        // debugPrint(text);
        //setState(() {});
      } else if (response.statusCode >= 400 && response.statusCode <= 499) {
        debugPrint(response.body);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    debugPrint(
        'time elapsed transcripting ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
  }

  String _checkReading(String arabicAyatext) {
    String y = '';
    try {
      y = StringSimilarity.needlemanWunsch(arabicAyatext, text);
    } on RangeError {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text(
      //         'You haven\'t completed recitation  please start again'),
      //     backgroundColor: Theme.of(context).errorColor,
      //   ),
      // );
    } catch (err) {
      debugPrint('Error occured');
    }
    return y;
  }

  String filepath = '';
  String filename = '';

  Future<void> _upload(
      model.User? user, String? filePath, String? fileName) async {
    File wavfile = File(filePath!);
    SettableMetadata metadata =
        SettableMetadata(customMetadata: user!.tojsonString());
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      var firebasefiledir = _firebaseStorage
          .ref()
          .child("wavfiles")
          .child(user.uid)
          .child(fileName!);
      await firebasefiledir.putFile(wavfile, metadata);
      debugPrint('time elapsed upload ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.stop();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<String> stopRecord(model.User? user, String arabicSurahText) async {
    await _record.stop();
    return (await _upload(user, filepath, filename)
        .then((value) async => await _speechToText(filename, user))
        .then((value) => text = _checkReading(arabicSurahText)));
  }

  void startRecord(String surahNo, String ayaNo) async {
    if (await _record.hasPermission()) {
      Directory directory = await getApplicationDocumentsDirectory();
      filename = "${surahNo}_${ayaNo}_$hashCode";
      filepath = '${directory.path}/$filename';
      //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
      await _record.start(
        path: filepath,
        encoder: AudioEncoder.wav, // by default
        bitRate: 256000, // by default
        samplingRate: 16000, // by default
        numChannels: 1,
      );
      debugPrint(filepath);
    }
  }
}
