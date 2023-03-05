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
    final index = args['index'];
    final surahName = args['surahName'];
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
      ),
      body: Container(
          child: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          return Column(
            children: [
              if (i == 0) const RetunBasmala(),
              Container(
                color: i % 2 != 0
                    ? const Color.fromARGB(255, 253, 251, 240)
                    : const Color.fromARGB(255, 253, 247, 230),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          quranList[index]['OrignalArabicText'][i],
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
              ),
            ],
          );
        },
        itemCount: quranList[index]['VerusCount'],
      )),
      bottomSheet: Container(
          decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: const BorderRadius.all(Radius.circular(20))),
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
