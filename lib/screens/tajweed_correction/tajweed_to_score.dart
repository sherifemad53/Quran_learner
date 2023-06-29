import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'tajweed_to_score_model.dart';

import '../../models/user_model.dart' as model;

class TajwedToScore {
  TajwedToScore._();
  static final instance = TajwedToScore._();

  String filepath = '';
  String filename = '';
  // final _record = Record();
  final _record = FlutterSoundRecorder();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<TajweedToScoreModel?> _tajwedToScore(String apiUrl,
      String? tajweedRule, String? filename, model.User? user) async {
    Stopwatch stopwatch = Stopwatch()..start();
    TajweedToScoreModel? tajwedtoscore;
    try {
      var uri = Uri.parse(apiUrl);
      var response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, List<String>>{
          'data': ['${user!.uid}/$tajweedRule/$filename']
        }),
      );

      try {
        if (response.statusCode == 200) {
          tajwedtoscore =
              tajweedToScoreModelFromJson(utf8.decode(response.bodyBytes));
        } else if (response.statusCode >= 400 && response.statusCode <= 499) {
          debugPrint(response.body);
        }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    } on FormatException catch (e) {
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    }

    debugPrint(
        'time elapsed transcripting ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
    return tajwedtoscore;
  }

  Future<void> _upload(model.User? user, String? tajweedRule, String? filePath,
      String? fileName) async {
    File wavfile = File(filePath!);
    SettableMetadata metadata =
        SettableMetadata(customMetadata: user!.tojsonString());
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      Reference firebasefiledir = _firebaseStorage
          .ref()
          .child("wavfiles")
          .child(user.uid)
          .child(tajweedRule!)
          .child(fileName!);
      await firebasefiledir.putFile(wavfile, metadata);
      debugPrint('time elapsed upload ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.stop();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Random random = Random();
  Future<TajweedToScoreModel?> record(
      String? apiUrl, model.User? user, String tajweedRule) async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    } else {
      Stopwatch stopwatch = Stopwatch()..start();
      int counter = 0;
      await _record.openRecorder();
      Directory directory = await getApplicationDocumentsDirectory();
      counter = random.nextInt(0xffffffff);
      filename = "${tajweedRule}_$counter.wav";
      filepath = '${directory.path}/$filename';
      //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs

      await _record.startRecorder(
        numChannels: 1,
        bitRate: 256000,
        codec: Codec.pcm16WAV,
        sampleRate: 16000,
        toFile: filepath,
      );

      debugPrint(filepath);
      await Future.delayed(const Duration(seconds: 5));

      await _record.stopRecorder();
      await _record.closeRecorder();

      debugPrint('time elapsed recording ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.stop();

      await _upload(user, tajweedRule, filepath, filename);
      return await _tajwedToScore(apiUrl!, tajweedRule, filename, user);
    }
  }
}
