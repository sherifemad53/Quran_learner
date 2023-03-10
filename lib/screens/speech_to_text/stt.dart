import 'dart:async';
import 'dart:convert';

//TODO: Remove dart:io package to make the app support web
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'components/quran_list.dart';
import 'components/string_similarity.dart';
import 'components/decodeSTT.dart';

import '../../providers/user_provider.dart';
import '../../model/user_model.dart' as model;
import '../../common/constants.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final record = Record();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  int? counter;

  bool isListening = false;
  bool isRecording = false;
  bool isRecorded = false;
  bool isLoading = false;
  bool isUploaded = false;
  bool isPlaying = false;
  bool _isChecked = false;

  String? _filepath;
  String? _filename;
  String? _selectSurahName;

  String text = "Press the Button and start speaking";

  var quranWords = List<Map<String, dynamic>>.filled(
      0, {'word': 'str', 'value': 0.0},
      growable: true);

  //TODO make it in realtime not record and send
  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  Future<String> _speechToText(String filename, model.User user) async {
    var uri =
        Uri.parse('https://anzhir2011-quran-recitation.hf.space/run/predict');
    var response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'data': ['${user.uid}/$filename']
      }),
    );
    try {
      if (response.statusCode == 200) {
        text = decodeSttFromJson(utf8.decode(response.bodyBytes))
            .data!
            .elementAt(0);
        debugPrint(text);
        //setState(() {});
      } else if (response.statusCode >= 400 && response.statusCode <= 499) {
        debugPrint(response.body);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  void _checkReading(String? surahName) {
    //TODO
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
    int counter = 0;
    double t;
    try {
      if (textlist.length == speechedtext.length) {
        for (var element in textlist) {
          t = StringSimilarity.similarity(element, speechedtext[counter]);
          quranWords.add({'word': element, 'value': t});
          if (counter < speechedtext.length) {
            counter++;
          }
        }
      } else {
        for (var element in textlist) {
          t = StringSimilarity.similarity(element, speechedtext[counter]);
          quranWords.add({'word': element, 'value': t});
          if (counter < speechedtext.length) {
            counter++;
          }
        }
        print(speechedtext);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    setState(() {
      _isChecked = true;
    });
    print(quranWords);
  }

  Future<void> _record(model.User user) async {
    if (isRecording) {
      record.stop();
      _upload(user);
      setState(() {
        isRecording = false;
        isRecorded = true;
      });
    } else {
      if (await record.hasPermission()) {
        setState(() {
          isRecording = true;
          isRecorded = false;
        });

        Directory directory = await getApplicationDocumentsDirectory();
        Random random = Random();

        counter = random.nextInt(0xffffffff);
        _filename = "$counter.wav";
        _filepath = '${directory.path}/$_filename';

        //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
        await record.start(
          path: _filepath,
          encoder: AudioEncoder.wav, // by default
          bitRate: 256000, // by default
          samplingRate: 16000, // by default
          numChannels: 1,
        );
        await Future.delayed(const Duration(seconds: 20));
        await record.stop();

        _upload(user);
        setState(() {
          isRecording = false;
          isRecorded = true;
        });
        debugPrint(_filepath);
      }
    }
  }

  void _upload(model.User user) async {
    File wavfile = File(_filepath!);

    SettableMetadata metadata = SettableMetadata(customMetadata: {
      'uid': user.uid,
      'name': user.name,
      'username': user.username,
      'email': user.email,
      'gender': user.gender,
      'birthdate': user.birthdate.toString(),
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
      await firebasefiledir.putFile(wavfile, metadata);
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      isUploaded = true;
      isLoading = false;
    });
  }

  //Note: this is the new function to record and send to server for uploading
  bool isPressed = false;
  Future<void> _continousRecord(model.User user) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String? str;
    setState(() {
      isRecording = true;
      isRecorded = false;
    });
    Random random = Random();
    if (await record.hasPermission()) {
      while (isPressed) {
        counter = random.nextInt(0xffffffff);
        _filename = "$counter.wav";
        _filepath = '${directory.path}/$_filename';
        //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
        final recorder = FlutterSoundRecorder();
        await recorder.openRecorder();
        await recorder.startRecorder(
          toFile: _filepath,
          codec: Codec.pcm16WAV,
          bitRate: 256000,
          sampleRate: 16000,
          numChannels: 1,
        );
        await Future.delayed(const Duration(seconds: 5));
        await recorder.stopRecorder();
        await recorder.closeRecorder();

        // await record.start(
        //   path: _filepath,
        //   encoder: AudioEncoder.wav, // by default
        //   bitRate: 256000, // by default
        //   samplingRate: 16000, // by default
        //   numChannels: 1,
        // );
        // await Future.delayed(const Duration(seconds: 5));
        //  await record.stop();

        http.Response response;
        try {
          var url = Uri.parse('http://192.168.1.106:5000');
          var file = File(_filepath as String);
          var stream = await http.ByteStream(file.openRead()).toBytes();
          var length = await file.length();

          response = await http.post(url,
              headers: {HttpHeaders.contentTypeHeader: "audio/wav;"},
              body: stream);
          if (response.statusCode == 200) {
            debugPrint("File Uploaded");
          } else {
            debugPrint("Upload Failed");
          }
          // _upload(user);
        } on SocketException catch (e) {
          debugPrint(e.message);
        }
      }
    }
    setState(() {
      isRecording = false;
      isRecorded = true;
    });
  }

  final isSelected = false;

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: kdefualtHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: kdefualtVerticalPadding),
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Setect Sura",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "To Memoritize",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //const SizedBox(height: 10),
              //Choose surah listview
              //this container shows the spelled words
              Container(
                height: size.height * 0.35,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _selectSurahName = quranList[index]['SurahNameArabic'];
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text('${index + 1}'),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "سورة ${quranList[index]['SurahNameArabic']}",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(quranList[index]['SurahNameEnglish'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                      '${quranList[index]['VerusCount']} verus',
                                      style:
                                          Theme.of(context).textTheme.bodySmall)
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: quranList.length,
                ),
              ),
              //this container shows the wrong words and their correnction
              CustomTextView(isChecked: _isChecked, quranWords: quranWords),
              //buttons to upload and edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // if (isRecorded)
                  //   ElevatedButton.icon(
                  //     label: const Text("Upload"),
                  //     onPressed: () => _upload(user),
                  //     icon: const Icon(Icons.upload_file),
                  //   ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _record(user);
                      isPressed = !isPressed;
                      // _continousRecord(user);
                    },
                    icon: isRecording
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.mic),
                    label:
                        isRecording ? const Text("Stop") : const Text("Start"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isRecording ? Colors.red : Colors.grey),
                  ),
                  if (isUploaded)
                    ElevatedButton.icon(
                      onPressed: () {
                        _speechToText(_filename as String, user).whenComplete(
                            () => _checkReading(_selectSurahName));
                      },
                      icon: const Icon(Icons.text_snippet_sharp),
                      label: const Text("Test"),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextView extends StatelessWidget {
  const CustomTextView({
    Key? key,
    required bool isChecked,
    required this.quranWords,
  })  : isChecked = isChecked,
        super(key: key);

  final bool isChecked;
  final List<Map<String, dynamic>> quranWords;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      margin: const EdgeInsets.symmetric(vertical: kdefualtVerticalMargin),
      padding:
          const EdgeInsets.symmetric(horizontal: kdefualtHorizontalPadding),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 168, 202, 146),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: isChecked
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
    );
  }
}

class QuranListTile extends StatelessWidget {
  QuranListTile({super.key, required this.index, required this.isSelected});

  int index;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, style: BorderStyle.solid, color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: isSelected ? Colors.grey[700] : Colors.grey[200]),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text('${index + 1}'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "سورة ${quranList[index]['SurahNameArabic']}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quranList[index]['SurahNameEnglish'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${quranList[index]['VerusCount']} verse',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
