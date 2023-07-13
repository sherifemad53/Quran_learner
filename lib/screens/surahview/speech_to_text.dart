import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:quranic_tool_box/models/aya_model.dart';

import '../../common/navigator_key.dart';
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

  void _showError(String str, Color color) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(str),
        backgroundColor: color,
      ),
    );
  }

  String _checkReading(AyaModel ayaModel, bool isMemorizationMode) {
    String temp = (0.0).toString();
    if (isMemorizationMode) {
      if (ayaModel.arabicText == 'الم' && recitedText == 'الف لام ميم') {
        return (1.0).toString();
      } else if (ayaModel.arabicText == 'المص' &&
          recitedText == 'الف لام ميم صاد') {
        return (1.0).toString();
      }
      double simScore = 0.0;
      String t = ayaModel.arabicText;
      // final arabicPattern = RegExp(r'[^\u0627-\u064As]');
      // t = t
      //     .replaceAll('أ', 'ا')
      //     .replaceAll('إ', 'ا')
      //     .replaceAll('آ', 'ا')
      //     .replaceAll(' ۖ', '')
      //     .replaceAll('\u064B', '')
      //     .replaceAll('ۤ', '')
      // .replaceAll(arabicPattern, '')
      // .replaceAll('  ', ' ')
      // .trim();
      recitedText = recitedText.trim();
      print('recited text = $recitedText');
      print(recitedText.length);
      print(t.length);
      if (t.length < recitedText.length) {
        _showError('Not correct please try again', Colors.red);
        temp = (0.0).toString();
        debugPrint("orignal arabic text: $t");
      } else if (t.length >= recitedText.length) {
        simScore = StringSimilarity.similarity(t, recitedText);
        if (simScore > 0.9) {
          bool isAllrightWords = true;
          List<String> x = t.split(' ').toList();
          List<String> y = recitedText.split(' ').toList();
          if (x.length == y.length) {
            for (int i = 0; i < x.length; i += 1) {
              double q =
                  StringSimilarity.similarity(x.elementAt(i), y.elementAt(i));
              if (q != 1.0) {
                isAllrightWords = false;
                _showError('You said wrong word', Colors.red);
                break;
              }
            }
            if (isAllrightWords) {
              _showError(
                  'Correct the Verse index is increamented', Colors.green);
              return (1.0).toString();
            }
          } else {
            _showError('Please try again', Colors.red);
            temp = (0.5).toString();
          }
        }
        debugPrint("orignal arabic text: $t");
      } else {
        temp = (0.0).toString();
        _showError('Not correct please try again', Colors.red);
      }
    } else {
      recitedText = _swapShaddaPosition(recitedText);
      temp = StringSimilarity.needlemanWunsch(
          ayaModel.orignalArabicText.trim(), recitedText.trim());
      debugPrint("orignal arabic text: ${ayaModel.orignalArabicText}");
    }
    debugPrint("transcripted text: $recitedText");
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
      /// Define the Firebase Storage reference for the WAV file
      Reference firebasefiledir = _firebaseStorage
          .ref()
          .child("wavfiles")
          .child(user.uid)
          .child(fileName!);

      /// Upload the WAV file to Firebase Storage with the specified metadata
      await firebasefiledir.putFile(wavfile, metadata);
    } catch (error) {
      /// Handle and print any errors that occur during the upload process
      debugPrint(error.toString());
    }
  }

  Future<String> stopRecord(
      model.User? user, AyaModel ayamodel, bool isMemorizationMode) async {
    String apiUrl;

    /// Stop and close the recorder
    await _recordnew.stopRecorder();
    await _recordnew.closeRecorder();

    await _upload(user, filepath, filename);
    if (isMemorizationMode) {
      apiUrl =
          'https://omarelsayeed-quran-recitation-google.hf.space/run/predict';
    } else {
      apiUrl =
          'https://omarelsayeed-quran-recitation-wav2vecdup.hf.space/run/predict';
    }
    await _speechToText(apiUrl, filename, user);
    return _checkReading(ayamodel, isMemorizationMode);
  }

  void startRecord(AyaModel ayaModel) async {
    /// Request microphone permission
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showError("Please check microphone permisson", Colors.red);

      /// Throw an exception if the microphone permission is not granted
      throw RecordingPermissionException("Microphone permission not granted");
    } else {
      // Open the recorder and set the file path
      await _recordnew.openRecorder();
      Directory directory = await getApplicationDocumentsDirectory();

      filename =
          "${ayaModel.surahNo}_${ayaModel.ayahNo}_${Random().nextInt(0xffffffff)}.wav";
      filepath = '${directory.path}/$filename';

      /// Start the recorder with specific audio configurations
      /// bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
      await _recordnew.startRecorder(
        numChannels: 1,
        bitRate: 192000,
        codec: Codec.pcm16WAV,
        sampleRate: 16000,
        toFile: filepath,
      );

      /// Output the file path for debugging purposes
      debugPrint(filepath);
    }
  }
}
