import 'dart:io';
import 'dart:math';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/user_model.dart' as model;

class SpeechToText {
  SpeechToText._();
  static final instance = SpeechToText._();

  String recitedText = '';
  String filepath = '';
  String filename = '';
  String apiUrl = '';
  // final _record = Record();
  final _record = FlutterSoundRecorder();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
  Future<void> record(model.User? user, String tajweedRule) async {
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
      return await _upload(user, tajweedRule, filepath, filename);
    }
  }
}
