import 'package:flutter/material.dart';
import '../../models/verse_similarity_model.dart';

import 'package:quranic_tool_box/services/senstence_Similarity_api_handler.dart';
import 'widgets/veruscard.dart';
import '../../utils/utils.dart';

class VerseSimilarityScreen extends StatefulWidget {
  const VerseSimilarityScreen({Key? key}) : super(key: key);

  @override
  State<VerseSimilarityScreen> createState() => _VerseSimilarityScreenState();
}

class _VerseSimilarityScreenState extends State<VerseSimilarityScreen> {
  Future<List<VersesSimilarityModel>>? similarityData;
  // String? _qarunVersetext;
  bool isFirstSearch = true;
  bool ishadith = false;

  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VERSE  SIMILARITY',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 6,
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
            Expanded(
              child: FutureBuilder(
                  future: similarityData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Center(child: CircularProgressIndicator.adaptive()),
                      );
                    } else if (snapshot.hasError) {
                      return const Card(child: Text('An error Occured'));
                    } else if (snapshot.data == null) {
                      return const Center(
                        child: Text(""),
                      );
                    } else {
                      return ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
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
                                ayaText: snapshot.data![index].similarSentence,
                                similartyScore:
                                    snapshot.data![index].similarityScore);
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
