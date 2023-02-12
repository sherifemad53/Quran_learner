import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'api_handling/sentencesimilarity_json.dart';
import 'package:http/http.dart' as http;

import 'components/veruscard.dart';

class SentenceSimilarityScreen extends StatefulWidget {
  const SentenceSimilarityScreen({Key? key}) : super(key: key);

  @override
  State<SentenceSimilarityScreen> createState() =>
      _SentenceSimilarityScreenState();
}

class _SentenceSimilarityScreenState extends State<SentenceSimilarityScreen> {
  final String _qarunVersehint = 'Enter Verus here';
  Future? similarityData;
  String? _qarunVersetext;

  TextEditingController myController = TextEditingController();

  //var _isSearching = false;
  //bool _isloaded = false;

  Future<Datum> tpgetData(text) async {
    //static int counter = 0;
    debugPrint("loaded again");
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
    for (int i = 0; i < s.length; i++) {
      int c = s.codeUnitAt(i);
      if (c >= 0x0600 && c <= 0x06E0) {
        return true;
      }
    }
    return false;
  }

  //FIXME:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Theme.of(context).primaryColor,
          child: const Text(
            'S E N T E N S E  S I M I L A R I T Y',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      /*
      TODO: 1- search bar doesn't load the body each time even on submiting (done)
      TODO: 2- Should check if the entered language was arabic first before fetching data (done)
      TODO: 4- add a filter for choosing the Aya quran 
      TODO: 5- remember the searched data 
      TODO: 6- add clear button to search bar (done)
      */
      body: SingleChildScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          //border: const OutlineInputBorder(),
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          //suffixIcon: const Icon(Icons.search),
                          hintText: _qarunVersehint,
                        ),
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          if (isProbablyArabic(value)) {
                            setState(() {
                              _qarunVersetext = value;
                              //_isloaded = true;
                              similarityData = tpgetData(_qarunVersetext);
                            });
                          }
                        },
                        onTap: () {},
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          myController.clear();
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
              //const SizedBox.shrink(),
              FutureBuilder(
                  future: similarityData,
                  builder: (context, snapshot) {
                    //_isSearching = false;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    } else if (snapshot.hasError) {
                      return const Card(child: Text('An error Occured'));
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: Text("Please enter a verus"),
                      );
                    } else {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.confidences!.length,
                          itemBuilder: (BuildContext context, int index) {
                            //_isloaded = false;
                            return VerusCard(
                                label: snapshot.data!.confidences![index].label,
                                confidance: snapshot
                                    .data!.confidences![index].confidence!);
                          });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
