import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  //var db = FirebaseFirestore.instance;
  var counter = 0;

  bool isListening = false;
  bool isRecording = false;
  bool isRecorded = false;
  bool isLoading = false;
  bool isUploaded = false;
  bool isPlaying = false;
  // bool doneUploading = false;

  String? _filepath;
  String? _filename;
  String? _selectSurahName;

  Duration? duration = Duration.zero;
  Duration? position = Duration.zero;

  String text = "Press the Button and start speaking";

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

  Future<String> _speechToText() async {
    //print(_filename);
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
        'data': [_filename!]
      }),
    );
    try {
      if (post.statusCode == 200) {
        var data = decodeSttFromJson(utf8.decode(post.bodyBytes));
        text = data.data!.elementAt(0);
        setState(() {});
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
    //TODO: Give some meta data like age and gender
    //TODO: Use better naming to keep track of each user record

    File wavfile = File(_filepath!);
    try {
      setState(() {
        isLoading = true;
      });
      final ref =
          FirebaseStorage.instance.ref().child("wavfiles").child(_filename!);
      await ref.putFile(wavfile).whenComplete(() => debugPrint("done++"));
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      isUploaded = true;
      isLoading = false;
    });
  }

  void _checkReading(String? surahName) {
    var arabicQurantext = quranList
        .firstWhere((element) => element['SurahNameArabic'] == surahName);
    List<String> textlist = [], speechedtext = [];
    speechedtext = text.split(' ');
    //print(arabicQurantext['ArabicText'].toString().split(' '));
    for (var elm in arabicQurantext['ArabicText'].toString().split(" ")) {
      textlist.add(elm.replaceFirst(',', '').trim());
    }
    int counter = 0;
    double t;
    for (var element in textlist) {
      t = StringSimilarity.similarity(element, speechedtext[counter]);
      if (t >= 0.75) {
        print('$element good');
      } else {
        print('$element bad');
      }
      if (counter < speechedtext.length) {
        counter++;
      }
    }
    // print(StringSimilarity.similarity(
    //     arabicQurantext['ArabicText'].toString(), text));
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
        Directory directory = await getApplicationDocumentsDirectory();
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
            //TODO: this container shows the spelled words
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(20),
                child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            //TODO: this container shows the wrong words and their correnction
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      _speechToText();
                      _checkReading(_selectSurahName);
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
