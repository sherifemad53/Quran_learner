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

import 'basmallah.dart';
import 'surah_view_settings.dart';
import 'speech_to_text.dart';

class SurahViewScreen extends StatefulWidget {
  const SurahViewScreen({super.key});
  @override
  State<SurahViewScreen> createState() => _SurahViewScreenState();
}

class _SurahViewScreenState extends State<SurahViewScreen> {
  model.User? user;

  String text = '';
  String htmlString = '';
  String needleManString = '';
  double similarityScore = 0.0;

  SettingsProvider? settingsProvider;
  final String quranfont = 'QuranFont2';
  double? quranfontSize = 24;

  SurahProvider surahProvider = SurahProvider();
  List<AyaModel>? ayas;
  String memorizationPercentage = '';

  void calculateMemorization() {
    double temp = 0;
    for (var element in ayas!) {
      if (element.isMemorized == true) {
        temp += 1;
      }
    }
    memorizationPercentage = ((temp / ayas!.length) * 100).toStringAsFixed(2);
  }

  void getAyas(String surahNameArabic, String surahNo) async {
    await surahProvider.init();
    ayas = await surahProvider.getSurahBySurahNameAndSurahNo(
        surahNameArabic, surahNo);

    calculateMemorization();

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
  bool isViewMoreInfo = false;
  bool isScrolling = false;
  bool? _isEnglishTransEnabled = false;

  String? surahName;
  String? surahNo;

  int verseNumber = 1;
  double? bottomBarHeight;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    settingsProvider = Provider.of<SettingsProvider>(context);

    quranfontSize = settingsProvider!.getSurahViewFontSize;
    _isEnglishTransEnabled = settingsProvider!.getIsEnglishTransEnabled;

    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    surahName = args['SurahNameArabic'];
    surahNo = args['SurahNo'];
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
              title: Text(
                surahName!,
                style: TextStyle(fontFamily: quranfont, fontSize: 24),
              ),
              actions: [
                Row(
                  children: [
                    if (isMemoriztingMode)
                      Text(
                        'Memorization: $memorizationPercentage%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
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
                if (!isScrolling) const BasmallahBar(),
                Expanded(
                  child: GestureDetector(
                    onVerticalDragDown: (details) {
                      setState(() {
                        isScrolling = true;
                        bottomBarHeight = 0;
                      });
                    },
                    child: ListView.builder(
                      addRepaintBoundaries: true,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 7),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          borderRadius: const BorderRadius.all(
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
                                          textDirection: TextDirection.rtl,
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
                                          vertical: 3, horizontal: 10.0),
                                      child: Text(
                                          ayas![index].englishTranslation,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: ayas!.length,
                    ),
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () {
                    isViewMoreInfo = !isViewMoreInfo;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color.fromARGB(255, 158, 187, 201)
                            : const Color.fromARGB(255, 211, 207, 198),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!isMemoriztingMode && isViewMoreInfo)
                          Html(data: text),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      isMemoriztingMode
                                          ? "Memorization Mode"
                                          : "Recitaion Mode",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                    "Begin from Verse ($verseNumber)",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                        .stopRecord(
                                            user,
                                            ayas![verseNumber - 1],
                                            isMemoriztingMode)
                                        .then((value) {
                                        if (isMemoriztingMode) {
                                          if (double.parse(value) >= 0.9) {
                                            ayas![verseNumber - 1].isMemorized =
                                                true;
                                            calculateMemorization();
                                            if (ayas!.length > verseNumber) {
                                              verseNumber += 1;
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content: Text(
                                                      'Congradulations You have memorized the Surah'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          }
                                        } else {
                                          text = value;
                                          isViewMoreInfo = true;
                                        }
                                        setState(() {});
                                      });
                              },
                              icon: Icon(isPressed ? Icons.stop : Icons.mic,
                                  color: Colors.black),
                              label: Text(
                                isPressed ? "Stop" : "Start",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  backgroundColor:
                                      isPressed ? Colors.red : Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
