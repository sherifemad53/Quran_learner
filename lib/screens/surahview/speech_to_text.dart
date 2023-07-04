import 'dart:convert';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../utils/string_similarity.dart';
import '../../models/speech_to_text_model.dart';

import '../../models/user_model.dart' as model;

class SpeechToText {
  SpeechToText._();
  static final instance = SpeechToText._();

  String recitedText = '';
  String filepath = '';
  String filename = '';
  String apiUrl = '';

  final _recordnew = FlutterSoundRecorder();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> _speechToText(
      String apiUrl, String? filename, model.User? user) async {
    /// Start a stopwatch to measure the transcripting time
    Stopwatch stopwatch = Stopwatch()..start();

    try {
      /// Parse the API URL
      var uri = Uri.parse(apiUrl);

      /// Make a POST request to the API to perform speech-to-text transcription
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
        /// Check the response status code
        if (response.statusCode == 200) {
          /// Parse the response and extract the recited text
          recitedText =
              speechToTextModelFromJson(utf8.decode(response.bodyBytes))
                  .data!
                  .elementAt(0);
          debugPrint(recitedText);
        } else if (response.statusCode >= 400 && response.statusCode <= 499) {
          /// Handle client errors with status code (4xx)
          debugPrint(response.body);
        }
      } on Exception catch (e) {
        /// Handle and print any exceptions that occur during parsing
        debugPrint(e.toString());
      }
    } on FormatException catch (e) {
      /// Handle and print any format exceptions that occur
      debugPrint(e.message);
    }

    /// Output the elapsed time for the transcripting process
    debugPrint(
        'time elapsed transcripting ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
  }

  /// Returns Swap the positions of shadda and diacritic mark
  String _swapShaddaPosition(String input) {
    RegExp regex = RegExp(r'[َُِ]ّ');

    /// Regular expression to match fatha, kasra, or dama followed by shadda

    String modifiedInput = input.replaceAllMapped(regex, (match) {
      String diacriticMark = match.group(0)![0];
      String shadda = match.group(0)![1];
      return shadda + diacriticMark;

      /// Swap the positions of shadda and diacritic mark
    });
    return modifiedInput;
  }

  String _checkReading(String arabicAyatext, bool isMemorizationMode) {
    String temp = '';
    int threshold = 5;
    print(arabicAyatext);
    if (isMemorizationMode) {
      if (arabicAyatext.length + threshold >= recitedText.length) {
        temp =
            StringSimilarity.similarity(arabicAyatext, recitedText).toString();
      } else {
        temp = (0.0).toString();
      }
    } else {
      recitedText = _swapShaddaPosition(recitedText);
      temp = StringSimilarity.needlemanWunsch(arabicAyatext, recitedText);
    }

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
    /// Create a File object from the provided file path
    File wavfile = File(filePath!);

    /// Create metadata with custom user information
    SettableMetadata metadata =
        SettableMetadata(customMetadata: user!.tojsonString());

    try {
      /// Start a stopwatch to measure the upload time
      Stopwatch stopwatch = Stopwatch()..start();

      /// Define the Firebase Storage reference for the WAV file
      Reference firebasefiledir = _firebaseStorage
          .ref()
          .child("wavfiles")
          .child(user.uid)
          .child(fileName!);

      /// Upload the WAV file to Firebase Storage with the specified metadata
      await firebasefiledir.putFile(wavfile, metadata);

      /// Output the elapsed time for the upload process for debugging puprose
      debugPrint('time elapsed upload ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.stop();
    } catch (error) {
      /// Handle and print any errors that occur during the upload process
      debugPrint(error.toString());
    }
  }

  Future<String> stopRecord(String apiUrl, model.User? user,
      String arabicSurahText, bool isMemorizationMode) async {
    /// Stop and close the recorder
    await _recordnew.stopRecorder();
    _recordnew.closeRecorder();

    /// Perform the upload, speech-to-text, and check the recited text
    return (await _upload(user, filepath, filename)
        .then((value) async => await _speechToText(apiUrl, filename, user))
        .then((value) =>
            recitedText = _checkReading(arabicSurahText, isMemorizationMode)));
  }

  void startRecord(String surahNo, String ayaNo) async {
    /// Request microphone permission
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      /// Throw an exception if the microphone permission is not granted
      throw RecordingPermissionException("Microphone permission not granted");
    } else {
      // Open the recorder and set the file path
      await _recordnew.openRecorder();
      Directory directory = await getApplicationDocumentsDirectory();
      filename = "${surahNo}_${ayaNo}_$hashCode.wav";
      filepath = '${directory.path}/$filename';

      /// Start the recorder with specific audio configurations
      /// bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
      await _recordnew.startRecorder(
        numChannels: 1,
        // bitRate: 256000,
        codec: Codec.pcm16WAV,
        sampleRate: 16000,
        toFile: filepath,
      );

      /// Output the file path for debugging purposes
      debugPrint(filepath);
    }
  }
}
