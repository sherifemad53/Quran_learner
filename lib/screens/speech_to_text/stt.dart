import 'dart:async';
import 'dart:convert';

//TODO: Remove dart:io package to make the app support web
import 'dart:io';
import 'dart:math';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'components/quran_list.dart';
import '../surahview/string_similarity.dart';
import 'components/decodeSTT.dart';

import '../../providers/user_provider.dart';
import '../../models/user_model.dart' as model;
import '../../common/constants.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final record = Record();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  bool isListening = false;
  bool isRecording = false;
  bool isRecorded = false;
  bool isUploaded = false;
  bool _isChecked = false;

  String? _selectSurahName;

  String text = '';

  var quranWords = List<Map<String, dynamic>>.filled(
      0, {'word': 'str', 'value': 0.0},
      growable: true);

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  Future<void> _speechToText(String? filename, model.User user) async {
    // print('start transcripting');
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
    debugPrint(
        'time elapsed transcripting ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
  }

  String _checkReading(String? surahName) {
    setState(() {
      _isChecked = false;
    });
    quranWords.clear();
    var arabicQurantext = quranList
        .firstWhere((element) => element['SurahNameArabic'] == surahName);
    var temp = '';
    var y = '';
    for (var element in (arabicQurantext['ArabicText'] as List)) {
      temp = '$temp ' + element;
    }

    try {
      y = StringSimilarity.needlemanWunsch(temp, text);
    } on RangeError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'You haven\'t completed recitation  please start again'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      debugPrint('Error occured');
    }
    setState(() {
      _isChecked = true;
    });
    debugPrint(quranWords.toString());
    return y;
  }

  String filepath = '';
  String filename = '';

  Future<void> _record(model.User user) async {
    int index = 0;
    int counter = 0;
    if (isRecording) {
      setState(() {
        isRecording = false;
        isRecorded = true;
      });
      await record.stop();
      await _upload(user, filepath, filename)
          .then((value) async => await _speechToText(filename, user))
          .then((value) => text = _checkReading(_selectSurahName));
    } else {
      if (await record.hasPermission()) {
        setState(() {
          isRecording = true;
          isRecorded = false;
        });
        Directory directory = await getApplicationDocumentsDirectory();
        Random random = Random();
        counter = random.nextInt(0xffffffff);
        filename = "$counter.wav";
        filepath = '${directory.path}/$filename';
        //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
        await record.start(
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

  Future<void> _upload(
      model.User user, String? filePath, String? fileName) async {
    File wavfile = File(filePath!);

    SettableMetadata metadata =
        SettableMetadata(customMetadata: user.tojsonString());
    try {
      // setState(() {
      //   isLoading = true;
      // });
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
    // setState(() {
    //   isUploaded = true;
    // });
    // debugPrint('done uploading');
  }

  // Note: this is the new function to record and send to server for uploading
  // Future<void> _continousRecord(model.User user) async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String? str;
  //   setState(() {
  //     isRecording = true;
  //     isRecorded = false;
  //   });
  //   Random random = Random();
  //   if (await record.hasPermission()) {
  //     while (isPressed) {
  //       counter = random.nextInt(0xffffffff);
  //       _filename = "$counter.wav";
  //       _filepath = '${directory.path}/$_filename';
  //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
  //       final recorder = FlutterSoundRecorder();
  //       await recorder.openRecorder();
  //       await recorder.startRecorder(
  //         toFile: _filepath,
  //         codec: Codec.pcm16WAV,
  //         bitRate: 256000,
  //         sampleRate: 16000,
  //         numChannels: 1,
  //       );
  //       await Future.delayed(const Duration(seconds: 5));
  //       await recorder.stopRecorder();
  //       await recorder.closeRecorder();
  // await record.start(
  //   path: _filepath,
  //   encoder: AudioEncoder.wav, // by default
  //   bitRate: 256000, // by default
  //   samplingRate: 16000, // by default
  //   numChannels: 1,
  // );
  // await Future.delayed(const Duration(seconds: 5));
  //  await record.stop();
  //       http.Response response;
  //       try {
  //         var url = Uri.parse('http://192.168.1.106:5000');
  //         var file = File(_filepath as String);
  //         var stream = await http.ByteStream(file.openRead()).toBytes();
  //         var length = await file.length();
  //         response = await http.post(url,
  //             headers: {HttpHeaders.contentTypeHeader: "audio/wav;"},
  //             body: stream);
  //         if (response.statusCode == 200) {
  //           debugPrint("File Uploaded");
  //         } else {
  //           debugPrint("Upload Failed");
  //         }
  //  _upload(user);
  //       } on SocketException catch (e) {
  //         debugPrint(e.message);
  //       }
  //     }
  //   }
  //   setState(() {
  //     isRecording = false;
  //     isRecorded = true;
  //   });
  // }

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
              const CustomSTTappBar(),
              //const SizedBox(height: 10),
              //Choose surah listview
              //this container shows the spelled words
              Card(
                child: Center(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _selectSurahName == null
                            ? ''
                            : _selectSurahName.toString(),
                        style: Theme.of(context).textTheme.headlineLarge,
                      )),
                ),
              ),
              Card(
                child: Container(
                  height: size.height * 0.35,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectSurahName =
                                quranList[index]['SurahNameArabic'];
                          });
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  ],
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() {
                                _selectSurahName =
                                    quranList[index]['SurahNameArabic'];
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: quranList.length,
                  ),
                ),
              ),
              //this container shows the wrong words and their correnction
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    vertical: kdefualtVerticalMargin),
                padding: const EdgeInsets.symmetric(
                    horizontal: kdefualtHorizontalPadding),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 179, 145),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: _isChecked
                    ? Html(data: text)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              //buttons to upload and edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _record(user);
                      //isRecording = !isRecording;
                      // isPressed = !isPressed;
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSTTappBar extends StatelessWidget {
  const CustomSTTappBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kdefualtVerticalPadding),
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
