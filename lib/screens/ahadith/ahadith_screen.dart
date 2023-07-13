import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../../common/constants.dart';
import '../../utils/utils.dart';
import '../../models/ahadith_model.dart';

import '../../services/athadith_api_handler.dart';

class AhadithScreen extends StatefulWidget {
  const AhadithScreen({super.key});

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  final TextEditingController myController = TextEditingController();
  Future<List<AhadithModel>>? similarAhadithList;

  @override
  void dispose() {
    super.dispose();
    FocusNode().unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AHADITH  SIMILARITY',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            similarAhadithList = similarAhadithApi(value);
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
                  future: similarAhadithList,
                  builder: (context, snapshot) {
                    //_isSearching = false;
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
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            //_isloaded = false;
                            return Card(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      snapshot.data!
                                          .elementAt(index)
                                          .similarSentence,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  SizedBox(
                                    //fit: FlexFit.tight,
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    //color: Colors.red,
                                    child: FAProgressBar(
                                      animatedDuration:
                                          const Duration(milliseconds: 1000),
                                      maxValue: 100,
                                      currentValue: snapshot.data!
                                              .elementAt(index)
                                              .similarityScore *
                                          100,
                                      displayText: '%',
                                      progressGradient: LinearGradient(
                                        colors: [
                                          kSecendoryColor.withOpacity(0.75),
                                          kBackgroundColor.withOpacity(0.75),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            );
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
