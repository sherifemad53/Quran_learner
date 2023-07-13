import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:quranic_tool_box/models/aya_model.dart';
import 'package:quranic_tool_box/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/surah_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart' as model;

import 'surah_view_settings.dart';
import 'speech_to_text.dart';

class SurahViewScreen extends StatefulWidget {
  const SurahViewScreen({super.key});
  @override
  State<SurahViewScreen> createState() => _SurahViewScreenState();
}

class _SurahViewScreenState extends State<SurahViewScreen> {
  model.User? user;

  final String quranfont = 'Al_Qalam_Quran';
  double? quranfontSize = 24;

  String text = ' ';

  SurahProvider surahProvider = SurahProvider();
  List<AyaModel>? ayas;
  SettingsProvider? settingsProvider;
  String memorizationPercentage = '';

  void getAyas(String surahNameArabic, String surahNo) async {
    await surahProvider.init();
    ayas = await surahProvider.getSurahBySurahNameAndSurahNo(
        surahNameArabic, surahNo);

    double temp = 0;
    for (var element in ayas!) {
      if (element.isMemorized == true) temp += 1;
    }
    memorizationPercentage = ((temp / ayas!.length) * 100).toStringAsFixed(2);
    setState(() {
      isDoneLoading = true;
    });
  }

  @override
  void dispose() async {
    super.dispose();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        surahName!, ayas!.map((e) => jsonEncode(e.toJson())).toList());
  }

  bool isPressed = false;
  bool isDoneLoading = false;
  bool isMemoriztingMode = false;
  bool showAya = false;
  int verseNumber = 1;
  bool isScrolling = false;
  bool? _isEnglishTransEnabled = false;

  String? surahName;
  String? surahNo;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    settingsProvider = Provider.of<SettingsProvider>(context);
    quranfontSize = Provider.of<SettingsProvider>(context).getSurahViewFontSize;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    surahName = args['SurahNameArabic'];
    surahNo = args['SurahNo'];
    _isEnglishTransEnabled = settingsProvider!.getIsEnglishTransEnabled;
    if (settingsProvider!.getSurahViewMode == 'Recitation') {
      isMemoriztingMode = false;
    } else {
      isMemoriztingMode = true;
    }

    if (!isDoneLoading) {
      getAyas(surahName!, surahNo!);
    }

    return isDoneLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text(surahName!),
              actions: [
                Row(
                  children: [
                    if (isMemoriztingMode)
                      Text('Memorization: $memorizationPercentage%'),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return const SurahViewSettingsScreen();
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!isScrolling) const RetunBasmala(),
                SizedBox(
                  height: !isMemoriztingMode
                      ? MediaQuery.of(context).size.height * 0.70
                      : MediaQuery.of(context).size.height * 0.77,
                  child: GestureDetector(
                    onVerticalDragDown: (details) {
                      setState(() {
                        isScrolling = true;
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (isMemoriztingMode) {
                          if (ayas![index].isMemorized!) {
                            ayas![index].isVisable = true;
                          } else {
                            ayas![index].isVisable = false;
                          }
                        } else {
                          ayas![index].isVisable = true;
                          ayas![index].isPressed = false;
                        }
                        return InkWell(
                          onTap: () {
                            setState(() {
                              verseNumber = index + 1;
                              if (isMemoriztingMode) {
                                ayas![index].isPressed =
                                    !ayas![index].isPressed;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 12),
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50))),
                                            child: Text(ayas![index].ayahNo),
                                          ),
                                          Visibility(
                                            visible: ayas![index].isPressed ||
                                                ayas![index].isMemorized! ||
                                                ayas![index].isVisable,
                                            child: Expanded(
                                              child: Text(
                                                ayas![index].orignalArabicText,
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: quranfontSize,
                                                  fontFamily: quranfont,
                                                  color: isDark
                                                      ? Colors.white
                                                      : const Color.fromARGB(
                                                          196, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_isEnglishTransEnabled != null)
                                        if (_isEnglishTransEnabled == true)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              ayas![index].englishTranslation,
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: quranfont,
                                                color: isDark
                                                    ? Colors.white54
                                                    : const Color.fromARGB(
                                                        196, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: ayas!.length,
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              height: !isMemoriztingMode
                  ? MediaQuery.of(context).size.height * 0.21
                  : MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blueGrey
                      : const Color.fromARGB(255, 211, 207, 198),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(7),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isMemoriztingMode)
                    text.isNotEmpty
                        ? Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                  child: Html(
                                data: text,
                              )),
                            ),
                          )
                        : const SizedBox(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                isMemoriztingMode
                                    ? "Memorization Mode"
                                    : "Recitaion Mode",
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              "Begin from Verse ($verseNumber)",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          isPressed = !isPressed;
                          setState(() {});
                          isPressed
                              ? SpeechToText.instance
                                  .startRecord(ayas![verseNumber - 1])
                              : SpeechToText.instance
                                  .stopRecord(user, ayas![verseNumber - 1],
                                      isMemoriztingMode)
                                  .then((value) {
                                  setState(() {});
                                  if (isMemoriztingMode) {
                                    if (double.parse(value) >= 0.9) {
                                      ayas![verseNumber - 1].isMemorized = true;
                                      if (ayas!.length > verseNumber) {
                                        double temp = 0;
                                        for (var element in ayas!) {
                                          if (element.isMemorized == true) {
                                            temp += 1;
                                          }
                                        }
                                        memorizationPercentage =
                                            ((temp / ayas!.length) * 100)
                                                .toStringAsFixed(2);

                                        verseNumber += 1;
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                                'Congradulations You have memorized the Surah'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    text = value;
                                  }
                                });
                        },
                        icon: Icon(isPressed ? Icons.stop : Icons.mic,
                            color: Colors.black),
                        label: Text(
                          isPressed ? "Stop" : "Start",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            backgroundColor:
                                isPressed ? Colors.red : Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class RetunBasmala extends StatelessWidget {
  const RetunBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(5),
        child: const Text(
          'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
          style: TextStyle(fontFamily: '110_Besmellah_Normal', fontSize: 30),
          // textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
