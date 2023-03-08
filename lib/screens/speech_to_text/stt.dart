import 'dart:async';
import 'dart:convert';

//TODO: Remove dart:io package to make the app support web
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_leaner/common/constants.dart';

import '../../providers/user_provider.dart';
import 'components/quran_list.dart';
import 'components/string_similarity.dart';
import 'components/decodeSTT.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../../model/user_model.dart' as model;

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final record = Record();
  final audioPlayer = AudioPlayer();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  //final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int? counter;

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

  // Duration? duration = Duration.zero;
  // Duration? position = Duration.zero;

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

  Future<String> _speechToText(String filename) async {
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
        print(text);
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

  // void _upload() async {
  //   //TODO: Give some meta data like age and gender (done)
  //   //TODO: Use better naming to keep track of each user record
  //   //TODO: ADD BUCKET(folder) FOR EACH USER (done)
  //   File wavfile = File(_filepath!);

  //   var user = _auth.currentUser!;
  //   var userdata =
  //       await _firebaseFirestore.collection('users').doc(user.uid).get();

  //   SettableMetadata metadata = SettableMetadata(customMetadata: {
  //     'uid': user.uid.toString(),
  //     'email': user.email.toString(),
  //     'gender': userdata['gender'].toString(),
  //     'birthdate': userdata['birthdate'].toString()
  //   });

  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     var firebasefiledir = _firebaseStorage
  //         .ref()
  //         .child("wavfiles")
  //         .child(user.uid)
  //         .child(_filename!);
  //     await firebasefiledir.putFile(wavfile);
  //     await firebasefiledir.updateMetadata(metadata);
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   }
  //   setState(() {
  //     isUploaded = true;
  //     isLoading = false;
  //   });
  // }

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
        // for (var element in textlist) {
        //   t = StringSimilarity.similarity(element, speechedtext[counter]);
        //   quranWords.add({'word': element, 'value': t});
        //   if (counter < speechedtext.length) {
        //     counter++;
        //   }
        // }
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

  // Check and request permission
  // Future<void> _record() async {
  // if (isRecording) {
  //   record.stop();
  //   setState(() {
  //     isRecording = false;
  //     isRecorded = true;
  //   });
  //     // Future aval = record.isRecording();
  //   } else {
  //     if (await record.hasPermission()) {
  //       Directory directory = await getApplicationDocumentsDirectory();
  //       //TODO CHANGE FILE NAME
  //       counter += 100;
  //       _filename = "$counter.wav";
  //       _filepath = '${directory.path}/$_filename';
  //       // Start recording
  //       setState(() {
  //         isRecording = true;
  //         isRecorded = false;
  //       });
  //       await record.start(
  //         path: _filepath,
  //         encoder: AudioEncoder.wav, // by default
  //         bitRate: 256000, // by default
  //         samplingRate: 16000, // by default
  //         numChannels: 1,
  //       );
  //       debugPrint(_filepath);
  //     }
  //   }
  // }

  // Future<void> _record() async {
  //   setState(() {
  //     isRecording = true;
  //     isRecorded = false;
  //   });
  //   if (await record.hasPermission()) {
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     //TODO CHANGE FILE NAME
  //     counter += 100;
  //     _filename = "$counter.wav";
  //     _filepath = '${directory.path}/$_filename';

  //     //bitrate = 16 per sample 16k  so  16 * 16k / 1000 kbs
  //     await record.start(
  //       path: _filepath,
  //       encoder: AudioEncoder.wav, // by default
  //       bitRate: 256000, // by default
  //       samplingRate: 16000, // by default
  //       numChannels: 1,
  //     );

  //     await Future.delayed(const Duration(seconds: 10));

  //     await record.stop();

  //     setState(() {
  //       isRecording = false;
  //       isRecorded = true;
  //     });
  //     debugPrint(_filepath);
  //   }
  // }

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

  bool isPressed = false;

  Future<void> _continousRecord(model.User user) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String? str;
    setState(() {
      isRecording = true;
      isRecorded = false;
    });
    Random random = Random();
    while (isPressed) {
      if (await record.hasPermission()) {
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

        await Future.delayed(const Duration(seconds: 5));
        str = await record.stop();
        print(str);
        http.StreamedResponse response;
        try {
          // var file = File(_filepath as String);
          // var request = http.MultipartRequest(
          //     'POST', Uri.parse('http://192.168.1.106/api/data'));

          // var xx = await file.readAsBytes();
          // var multipartFile = http.MultipartFile(
          //     'file', file.readAsBytes().asStream(), file.lengthSync(),
          //     filename: _filename);

          // request.files.add(multipartFile);
          // var response = await request.send();
          // print(xx.buffer);

          var url = Uri.parse('http://192.168.1.106/api/data');
          var file = File(_filepath as String);
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();

          var request = http.MultipartRequest("POST", url);
          request.headers["Content-Type"] = "multipart/form-data";
          var multipartFile = http.MultipartFile('file', stream, length,
              filename: basename(file.path));
          request.files.add(multipartFile);
          response = await request.send();

          if (response.statusCode == 200) {
            print("File Uploaded");
          } else {
            print("Upload Failed");
          }

          _upload(user);
        } on SocketException catch (e) {
          print(e.message);
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
      // appBar: AppBar(
      //   title: const Text(
      //     "M E M O R I Z A T I O N",
      //   ),
      // ),
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
                //padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _selectSurahName = quranList[index]['SurahNameArabic'];
                        print(_selectSurahName);
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    quranList[index]['SurahNameEnglish'],
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '${quranList[index]['VerusCount']} verus',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                  if (isRecorded)
                    ElevatedButton.icon(
                      label: const Text("Upload"),
                      onPressed: () => _upload(user),
                      icon: const Icon(Icons.upload_file),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // _record();
                      isPressed = !isPressed;
                      _continousRecord(user);
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
                        _speechToText(_filename as String).whenComplete(
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
                    '${quranList[index]['VerusCount']} verus',
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
