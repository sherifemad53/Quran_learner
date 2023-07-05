import 'package:flutter/material.dart';
import '../../models/senstense_similarity_model.dart';

import 'package:quranic_tool_box/services/senstence_Similarity_api_handler.dart';
import 'widgets/veruscard.dart';
import '../../utils/utils.dart';

class SentenceSimilarityScreen extends StatefulWidget {
  const SentenceSimilarityScreen({Key? key}) : super(key: key);

  @override
  State<SentenceSimilarityScreen> createState() =>
      _SentenceSimilarityScreenState();
}

class _SentenceSimilarityScreenState extends State<SentenceSimilarityScreen> {
  Future<List<SenstenceSimilarityModel>>? similarityData;
  // String? _qarunVersetext;
  bool isFirstSearch = true;
  bool ishadith = false;

  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SENTENSE  SIMILARITY',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        textDirection: TextDirection.rtl,
                        controller: myController,
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintTextDirection: TextDirection.ltr,
                            hintText: 'Enter Query',
                            prefixIcon: Icon(Icons.search)),
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          if (Utils.isProbablyArabic(value)) {
                            setState(() {
                              similarityData = similarVerseModelhApi(value);
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () => myController.clear(),
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            ),
            //const SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: similarityData,
                    builder: (context, snapshot) {
                      //_isSearching = false;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: CircularProgressIndicator.adaptive()),
                        );
                      } else if (snapshot.hasError) {
                        return const Card(child: Text('An error Occured'));
                      } else if (snapshot.data == null) {
                        return const Center(
                          child: Text(""),
                        );
                      } else {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              //_isloaded = false;
                              return VerusCard(
                                  ayaNum: snapshot.data![index].ayahNo,
                                  surahNum: snapshot.data![index].surahNumber,
                                  surahName: snapshot.data![index].surahName,
                                  ayaText:
                                      snapshot.data![index].similarSentence,
                                  similartyScore:
                                      snapshot.data![index].similarityScore);
                            });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
