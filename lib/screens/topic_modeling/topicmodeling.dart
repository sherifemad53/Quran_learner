import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:quran_leaner/components/topicmodeling_json.dart';
import 'package:http/http.dart' as http;

class TopicModelingScreen extends StatefulWidget {
  const TopicModelingScreen({Key? key}) : super(key: key);

  @override
  State<TopicModelingScreen> createState() => _TopicModelingScreenState();
}

class _TopicModelingScreenState extends State<TopicModelingScreen> {
  String? _qarunVersetext;
  var _isSearching = false;
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

  @override
  Widget build(BuildContext context) {
    //debugPrint('Build: Done -----------------------------------------------');
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blue,
          child: const Text(
            'Topic Modeling',
            style: TextStyle(fontSize: 20),
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            label: const Text('s'),
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: (() => setState(() {
                  _isSearching = true;
                })),
          )
        ],
      ),
      /*
      todo 1- search bar doesn't load the body each time even on submiting 
      todo 2- Should check if the entered language was arabic first before fetching data
      todo 3- should it has a Quran dict to check if the verse the entered corrent before fetching data?
      todo 4- add a filter for choosing the Aya quran
      todo 5- remember the searched data 
      todo 6- add clear button to search bar
      */
      body: SingleChildScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            _isSearching
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          _qarunVersetext = value;
                        });
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            FutureBuilder(
                future: tpgetData(_qarunVersetext),
                builder: (context, snapshot) {
                  _isSearching = false;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Card(child: Text(''));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.confidences!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: AutoSizeText(
                                            '${snapshot.data!.confidences?[index].label}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            wrapWords: true,
                                            minFontSize: 18,
                                            maxFontSize: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: 400,
                                          //color: Colors.red,
                                          child: FAProgressBar(
                                            currentValue: snapshot
                                                    .data!
                                                    .confidences![index]
                                                    .confidence! *
                                                100,
                                            displayText: '%',
                                            progressGradient: LinearGradient(
                                              colors: [
                                                Colors.blue.withOpacity(0.75),
                                                Colors.green.withOpacity(0.75),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
