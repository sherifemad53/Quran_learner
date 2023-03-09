import 'package:flutter/material.dart';

import 'api_handling/api.dart';
import 'widgets/veruscard.dart';
import '../../utils/utils.dart';

class SentenceSimilarityScreen extends StatefulWidget {
  const SentenceSimilarityScreen({Key? key}) : super(key: key);

  @override
  State<SentenceSimilarityScreen> createState() =>
      _SentenceSimilarityScreenState();
}

class _SentenceSimilarityScreenState extends State<SentenceSimilarityScreen> {
  Future? similarityData;
  String? _qarunVersetext;
  bool isFirstSearch = true;
  bool ishadith = false;

  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'S E N T E N S E  S I M I L A R I T Y',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      resizeToAvoidBottomInset: false,
      //TODO: 1- add a filter for choosing the Aya quran
      //TODO: 2- remember the searched data
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              textAlign: TextAlign.right,
                              controller: myController,
                              decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Enter text',
                              ),
                              keyboardType: TextInputType.text,
                              onSubmitted: (value) {
                                if (Utils.isProbablyArabic(value)) {
                                  setState(() {
                                    _qarunVersetext = value;
                                    //_isloaded = true;
                                    similarityData = tpgetData(_qarunVersetext);
                                  });
                                }
                              },
                              onTap: () {},
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Search in Ahadith ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch.adaptive(
                            value: ishadith,
                            onChanged: (value) {
                              setState(() {
                                ishadith = value;
                              });
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //const SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.71,
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
                            itemCount: snapshot.data!.confidences!.length,
                            itemBuilder: (BuildContext context, int index) {
                              //_isloaded = false;
                              return VerusCard(
                                  label:
                                      snapshot.data!.confidences![index].label,
                                  confidance: snapshot
                                      .data!.confidences![index].confidence!);
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
