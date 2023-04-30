import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../common/constants.dart';
import '../../data/quran_list.dart';
import '../../models/user_model.dart' as model;

import 'speech_to_text.dart';

class SurahViewScreen extends StatefulWidget {
  const SurahViewScreen({super.key});

  @override
  State<SurahViewScreen> createState() => _SurahViewScreenState();
}

class _SurahViewScreenState extends State<SurahViewScreen> {
  model.User? user;

  final String arabicFont = 'quran';
  final double arabicFontSize = 24;
  final double mushafFontSize = 40;

  String text = ' ';

  bool isPressed = false;
  var verseNumber = 1;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    String surahName = args['SurahNameArabic'];
    var selectedSurah = quranList
        .firstWhere((element) => element['SurahNameArabic'] == surahName);
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const RetunBasmala(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          verseNumber = i + 1;
                        });
                      },
                      child: Container(
                        color: i % 2 != 0
                            ? const Color.fromARGB(255, 253, 251, 240)
                            : const Color.fromARGB(255, 253, 247, 230),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                margin: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50))),
                                child: Text((i + 1).toString()),
                              ),
                              Expanded(
                                child: Text(
                                  selectedSurah['OrignalArabicText'][i],
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: arabicFontSize,
                                    fontFamily: arabicFont,
                                    color: const Color.fromARGB(196, 0, 0, 0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: selectedSurah['VerusCount'],
                ),
              ],
            ),
          )),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: const EdgeInsets.all(kdefualtPadding),
        width: double.infinity,
        child: Column(
          children: [
            FittedBox(
              child: text != null
                  ? SingleChildScrollView(child: Html(data: text))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Row(
              children: [
                Text(
                  "Verse no. $verseNumber",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Start Memorization"),
                IconButton(
                  onPressed: () async {
                    //TODO Auto increament if the memorization is correct by return bool if the memoriztion is true else a string with the incorrent words
                    isPressed = !isPressed;
                    setState(() {});
                    isPressed
                        ? SpeechToText.instance
                            .startRecord("1", verseNumber.toString())
                        : SpeechToText.instance
                            .stopRecord(user,
                                selectedSurah['ArabicText'][verseNumber - 1])
                            .then((value) {
                            text = value;
                            setState(() {});
                          });
                  },
                  icon: isPressed
                      ? const Icon(Icons.stop_circle)
                      : const Icon(Icons.mic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RetunBasmala extends StatelessWidget {
  const RetunBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(kdefualtPadding),
        child: Text(
          'بسم الله الرحمن الرحيم',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontFamily: 'me_quran', fontSize: 35),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
