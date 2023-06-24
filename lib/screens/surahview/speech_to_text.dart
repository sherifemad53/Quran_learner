import 'dart:convert';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'string_similarity.dart';
import 'decode_stt.dart';

import '../../models/user_model.dart' as model;

class SpeechToText {
  SpeechToText._();
  static final instance = SpeechToText._();

  String recitedText = '';
  String filepath = '';
  String filename = '';
  String apiUrl = '';
  // final _record = Record();
  final _recordnew = FlutterSoundRecorder();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> _speechToText(
      String apiUrl, String? filename, model.User? user) async {
    Stopwatch stopwatch = Stopwatch()..start();
    try {
      var uri =
          // Uri.parse('https://omarelsayeed-quran-recitation.hf.space/run/predict');
          Uri.parse(apiUrl);
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
          recitedText = decodeSttFromJson(utf8.decode(response.bodyBytes))
              .data!
              .elementAt(0);
          debugPrint(recitedText);
        } else if (response.statusCode >= 400 && response.statusCode <= 499) {
          debugPrint(response.body);
        }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    } on FormatException catch (e) {
      debugPrint(e.message);
    }
    debugPrint(
        'time elapsed transcripting ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
  }

  String _swapShaddaPosition(String input) {
    RegExp regex = RegExp(
        r'[َُِ]ّ'); // Regular expression to match fatha, kasra, or dama followed by shadda

    String modifiedInput = input.replaceAllMapped(regex, (match) {
      String diacriticMark = match.group(0)![0];
      String shadda = match.group(0)![1];
      return shadda +
          diacriticMark; // Swap the positions of shadda and diacritic mark
    });
    return modifiedInput;
  }

  String _checkReading(String arabicAyatext,bool isMemorizationMode) {
    String temp = '';
    recitedText = _swapShaddaPosition(recitedText);
    temp = isMemorizationMode ? StringSimilarity.similarity(arabicAyatext, recitedText).toString() : StringSimilarity.needlemanWunsch(arabicAyatext, recitedText);
    // if (arabicAyatext.length + 5 >= recitedText.length) {
    //   temp = StringSimilarity.needlemanWunsch(arabicAyatext, recitedText);
    // } else if (arabicAyatext.length + 5 < recitedText.length) {
    //   temp = 'Please say it again as it is wrong';
    // } else if(isMemorizationMode) {

    // }
    // try {
    // } on RangeError {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text(
    //           'You haven\'t completed recitation  please start again'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    // } catch (err) {
    //   debugPrint('Error occured');
    // }
    return temp;
  }

  Future<void> _upload(
      model.User? user, String? filePath, String? fileName) async {
    File wavfile = File(filePath!);
    SettableMetadata metadata =
        SettableMetadata(customMetadata: user!.tojsonString());
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      Reference firebasefiledir = _firebaseStorage
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

  Future<String> stopRecord(
      String apiUrl, model.User? user, String arabicSurahText,bool isMemorizationMode) async {
    await _recordnew.stopRecorder();
    _recordnew.closeRecorder();
    return (await _upload(user, filepath, filename)
        .then((value) async => await _speechToText(apiUrl, filename, user))
        .then((value) => recitedText = _checkReading(arabicSurahText,isMemorizationMode)));
  }

  void startRecord(String surahNo, String ayaNo) async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    } else {
      await _recordnew.openRecorder();
      Directory directory = await getApplicationDocumentsDirectory();
      filename = "${surahNo}_${ayaNo}_$hashCode.wav";
      filepath = '${directory.path}/$filename';
      //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
      await _recordnew.startRecorder(
        numChannels: 1,
        bitRate: 192000,
        codec: Codec.pcm16WAV,
        sampleRate: 20000,
        toFile: filepath,
      );
      debugPrint(filepath);
    }
  }
}
