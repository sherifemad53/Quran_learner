import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

//import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;

import 'decodeSTT.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  //stt.SpeechToText? speech;

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

  Duration? duration = Duration.zero;
  Duration? position = Duration.zero;

  String text = "Press the Button and start speaking";

  final record = Record();
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    //speech = stt.SpeechToText();
    //speech?.initialize();

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
        _filename = "${counter}.wav";

        print(_filename);

        _filepath = '${directory.path}/$_filename';
        // Start recording
        setState(() {
          isRecording = true;
          isRecorded = false;
        });

        //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
        //
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color,
                    fontSize: 20,
                  ),
                ),
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isRecorded)
                    IconButton(
                      onPressed: _upload,
                      icon: const Icon(Icons.upload_file),
                    ),
                  IconButton(onPressed: _record, icon: const Icon(Icons.mic)),
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
                      onPressed: _speechToText,
                      icon: const Icon(Icons.text_snippet_sharp),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (() => FirebaseFirestore.instance
      //           .collection("/users/n5XJX7gePIzV2xDt1ABW/messages")
      //           .snapshots()
      //           .listen((event) {
      //         event.docs.forEach((element) {
      //           print(element['text']);
      //         });
      //       })),
      //   child: Icon(isRecording ? Icons.mic : Icons.mic_none),
      // ),
    );
  }
}
