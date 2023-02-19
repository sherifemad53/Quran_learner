import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_leaner/screens/speech_to_text/components/quran_list.dart';
import 'package:quran_leaner/screens/speech_to_text/components/string_similarity.dart';

import 'components/decodeSTT.dart';
//import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

//import 'package:firebase_core/firebase_core.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  //stt.SpeechToText? speech;

  final record = Record();
  final audioPlayer = AudioPlayer();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //var db = FirebaseFirestore.instance;
  var counter = 0;

  bool isListening = false;
  bool isRecording = false;
  bool isRecorded = false;
  bool isLoading = false;
  bool isUploaded = false;
  bool isPlaying = false;
  bool _isChecked = false;
  // bool doneUploading = false;

  String? _filepath;
  String? _filename;
  String? _selectSurahName;

  Duration? duration = Duration.zero;
  Duration? position = Duration.zero;

  String text = "Press the Button and start speaking";

  var quranWords = List<Map<String, dynamic>>.filled(
      0, {'word': 'str', 'value': 0.0},
      growable: true);

  //TODO make it in realtime not record and send
  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
    });

    audioPlayer.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
    });
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  Future<String> _speechToText(
    String filename,
  ) async {
    //print(_filename);
    var user = _auth.currentUser!;
    var uri =
        Uri.parse('https://anzhir2011-quran-recitation.hf.space/run/predict');
    var post = await http.post(
      uri,
      headers: {
        // HttpHeaders.authorizationHeader:
        //     "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",
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'data': ['${user.uid}/$filename']
      }),
    );
    try {
      if (post.statusCode == 200) {
        text =
            decodeSttFromJson(utf8.decode(post.bodyBytes)).data!.elementAt(0);
        //print(text);
        //setState(() {});
      } else if (post.statusCode >= 400 && post.statusCode <= 499) {}
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  void _playRecorded() async {
    if (!isPlaying) {
      final fileSrc = DeviceFileSource(_filepath!);
      isPlaying = true;

      audioPlayer.play(fileSrc);
      audioPlayer.onPlayerComplete.listen((duration) {
        setState(() {
          isPlaying = false;
        });
      });
    } else {
      audioPlayer.pause();
      isPlaying = false;
    }
    setState(() {});
  }

  void _upload() async {
    //TODO: Give some meta data like age and gender (done)
    //TODO: Use better naming to keep track of each user record
    //TODO: ADD BUCKET(folder) FOR EACH USER (done)
    File wavfile = File(_filepath!);

    var user = _auth.currentUser!;
    var userdata =
        await _firebaseFirestore.collection('users').doc(user.uid).get();

    SettableMetadata metadata = SettableMetadata(customMetadata: {
      'uid': user.uid.toString(),
      'email': user.email.toString(),
      'gender': userdata['gender'].toString(),
      'birthdate': userdata['birthdate'].toString()
    });

    try {
      setState(() {
        isLoading = true;
      });
      var firebasefiledir = _firebaseStorage
          .ref()
          .child("wavfiles")
          .child(user.uid)
          .child(_filename!);
      await firebasefiledir
          .putFile(wavfile)
          .whenComplete(() => debugPrint(" uploaded completely ++"));
      await firebasefiledir.updateMetadata(metadata);
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      isUploaded = true;
      isLoading = false;
    });
  }

  void _checkReading(String? surahName) {
    setState(() {
      _isChecked = false;
      //quranWords.clear();
    });
    quranWords.clear();
    var arabicQurantext = quranList
        .firstWhere((element) => element['SurahNameArabic'] == surahName);
    List<String> textlist = [], speechedtext = [];
    speechedtext = text.split(' ');
    //print(arabicQurantext['ArabicText'].toString().split(' '));
    for (var elm in arabicQurantext['ArabicText'].toString().split(" ")) {
      textlist.add(elm
          .replaceFirst(',', '')
          .replaceFirst('[', '')
          .replaceFirst(']', '')
          .trim());
    }
    //print(textlist);

    int counter = 0;
    double t;
    for (var element in textlist) {
      t = StringSimilarity.similarity(element, speechedtext[counter]);
      quranWords.add({'word': element, 'value': t});
      if (counter < speechedtext.length) {
        counter++;
      }
    }
    //print(quranWords);
    // print(StringSimilarity.similarity(
    //     arabicQurantext['ArabicText'].toString(), text));
    setState(() {
      _isChecked = true;
    });
  }

  // Check and request permission
  Future<void> _record() async {
    if (isRecording) {
      record.stop();
      setState(() {
        isRecording = false;
        isRecorded = true;
      });
      // Future aval = record.isRecording();
    } else {
      if (await record.hasPermission()) {
        //TODO Clear wav files from device after a while
        Directory directory = await getApplicationDocumentsDirectory();
        //TODO CHANGE FILE NAME
        counter += 100;
        _filename = "$counter.wav";
        _filepath = '${directory.path}/$_filename';
        // Start recording
        setState(() {
          isRecording = true;
          isRecorded = false;
        });

        //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs

        await record.start(
          path: _filepath,
          encoder: AudioEncoder.wav, // by default
          bitRate: 256000, // by default
          samplingRate: 16000, // by default
          numChannels: 1,
        );
        debugPrint(_filepath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S P E E C H  T O  T E X T",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose Surah',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  DropdownButton<String>(
                    value: _selectSurahName,
                    isDense: false,
                    items: quranList.map((e) {
                      return DropdownMenuItem<String>(
                        value: e['SurahNameArabic'].toString(),
                        child: Text(
                          e['SurahNameArabic'].toString(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectSurahName = value;
                      });
                    },
                    hint: Text('Select'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            //this container shows the spelled words
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 112, 181, 183),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            //this container shows the wrong words and their correnction
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 168, 202, 146),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: _isChecked
                  ? RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: <TextSpan>[
                            for (var element in quranWords)
                              TextSpan(
                                  text: "${element['word']} ",
                                  style: TextStyle(
                                      color: element['value'] > 0.7
                                          ? Colors.black
                                          : Colors.red)),
                          ]))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            //player slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(position!.inSeconds.toString()),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Slider(
                    min: 0,
                    max: duration!.inSeconds.toDouble(),
                    value: position!.inSeconds.toDouble(),
                    onChanged: ((value) async {
                      final curPosition = Duration(seconds: value.toInt());
                      await audioPlayer.seek(curPosition);
                    }),
                  ),
                ),
                Text(duration!.inSeconds.toString()),
              ],
            ),
            //buttons to upload and edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isRecorded)
                  ElevatedButton.icon(
                    label: const Text("Upload"),
                    onPressed: _upload,
                    icon: const Icon(Icons.upload_file),
                  ),
                ElevatedButton.icon(
                  onPressed: () {
                    _record();
                  },
                  icon: isRecording
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.mic),
                  label: isRecording ? const Text("Stop") : const Text("Start"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording ? Colors.red : Colors.grey),
                ),
                isPlaying
                    ? IconButton(
                        onPressed: () async {
                          await audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        },
                        icon: const Icon(Icons.pause))
                    : IconButton(
                        onPressed: _playRecorded,
                        icon: const Icon(Icons.play_arrow)),
                if (isUploaded)
                  IconButton(
                    onPressed: () {
                      _speechToText(_filename as String)
                          .whenComplete(() => _checkReading(_selectSurahName));
                    },
                    icon: const Icon(Icons.text_snippet_sharp),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
