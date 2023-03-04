import 'package:flutter/material.dart';
import 'package:quran_leaner/common/constants.dart';

import 'api_handling/api.dart';
import 'components/veruscard.dart';
import '../../utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'S E N T E N S E  S I M I L A R I T Y',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),

      //TODO: 1- add a filter for choosing the Aya quran
      //TODO: 2- remember the searched data
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
                margin: const EdgeInsets.all(kdefualtMargin),
                padding: const EdgeInsets.symmetric(
                    horizontal: kdefualtHorizontalPadding),
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
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: _qarunVersehint,
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
