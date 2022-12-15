import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'api_handling/topicmodeling_json.dart';
import 'package:http/http.dart' as http;
import 'package:quran_leaner/constrains.dart';

import 'components/veruscard.dart';

class TopicModelingScreen extends StatefulWidget {
  const TopicModelingScreen({Key? key}) : super(key: key);

  @override
  State<TopicModelingScreen> createState() => _TopicModelingScreenState();
}

class _TopicModelingScreenState extends State<TopicModelingScreen> {
  final String _qarunVersehint = 'Enter Verus here';
  String? _qarunVersetext;
  //var _isSearching = false;
  //bool _isloading = true;

  Future<Datum> tpgetData(text) async {
    Tp jz;
    var uri = Uri.parse(
        'https://anzhir2011-sentencesimilarity-quran-v2.hf.space/api/predict');
    var post = await http.post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader:
            "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",
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'data': [text]
      }),
      //encoding: Encoding.getByName('utf-8'),
    );
    try {
      if (post.statusCode == 200) {
        jz = tpFromJson(utf8.decode(post.bodyBytes));
        return jz.data!.elementAt(0);
      } else if (post.statusCode >= 400 && post.statusCode <= 499) {
        debugPrint(post.statusCode.toString());
      }
    } on Exception catch (e) {
      debugPrint("Error: $e");
    }
    return Datum();
  }

  bool isProbablyArabic(String s) {
    for (int i = 0; i < s.length;) {
      int c = s.codeUnitAt(i);
      if (c >= 0x0600 && c <= 0x06E0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blue,
          child: const Text(
            'S E N T E N S E  S I M I L A R I T Y',
            style: TextStyle(fontSize: 20),
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () => setState(() {
        //       //_isSearching = true;
        //     }),
        //     icon: const Icon(Icons.search, color: Colors.white),
        //   )
        // ],
      ),
      /*
      todo 1- search bar doesn't load the body each time even on submiting 
      todo 2- Should check if the entered language was arabic first before fetching data
      todo 3- should it has a Quran dict to check if the verse the entered corrent before fetching data?
      todo 4- add a filter for choosing the Aya quran
      todo 5- remember the searched data 
      todo 6- add clear button to search bar
      */
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kSecendoryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        decoration: InputDecoration(
                          //border: const OutlineInputBorder(),
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          //suffixIcon: const Icon(Icons.search),
                          hintText: _qarunVersehint,
                          icon: const Icon(Icons.search),
                        ),
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          setState(() {
                            _qarunVersetext = value;
                            // _qarunVersehint = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          debugPrint("hello");
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
              //const SizedBox.shrink(),
              FutureBuilder(
                  future: tpgetData(_qarunVersetext),
                  builder: (context, snapshot) {
                    //_isSearching = false;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Card(child: Text(''));
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.confidences!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return VerusCard(
                                label: snapshot.data!.confidences![index].label,
                                confidance: snapshot
                                    .data!.confidences![index].confidence!);
                          });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
