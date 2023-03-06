import 'package:flutter/material.dart';
import 'package:quran_leaner/common/constants.dart';
import 'package:quran_leaner/screens/home_page/quran_list.dart';

class SurahViewScreen extends StatelessWidget {
  const SurahViewScreen({super.key});

  final String arabicFont = 'quran';
  final double arabicFontSize = 28;
  final double mushafFontSize = 40;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String surahName = args['SurahNameArabic'];
    var selectedSurah = quranList
        .firstWhere((element) => element['SurahNameArabic'] == surahName);
    // print(selectedSurah);
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
                    return Container(
                      color: i % 2 != 0
                          ? const Color.fromARGB(255, 253, 251, 240)
                          : const Color.fromARGB(255, 253, 247, 230),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
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
                            ),
                          ],
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
          decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          padding: const EdgeInsets.all(kdefualtPadding),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Start Memorization"),
              IconButton(
                onPressed: (() {}),
                icon: const Icon(Icons.mic),
              ),
            ],
          )),
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
