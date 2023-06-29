import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart' as model;

import 'tajweed_data.dart';
import 'tajweed_to_score.dart';
import 'tajweed_to_score_model.dart';

class TajweedCorrectionScreen extends StatefulWidget {
  const TajweedCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<TajweedCorrectionScreen> createState() =>
      _TajweedCorrectionScreenState();
}

class _TajweedCorrectionScreenState extends State<TajweedCorrectionScreen> {
  final isSelected = false;
  bool isRecording = false;
  bool isPressed = false;

  String? selectedRule = tajweedRulesData[0]['type'];
  int? selectedRuleIndex = 0;
  String? selectedWord;
  String? selectedApi;

  model.User? user;

  TajweedToScoreModel? tajweedscore;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: kdefualtHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButton(
                      isExpanded: true,
                      value: selectedRule,
                      items: tajweedRulesData.map(
                        (element) {
                          return DropdownMenuItem(
                            value: element['type'] as String,
                            child: Center(
                              child: Text(
                                element['type'] as String,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (selectedValue) {
                        setState(() {
                          debugPrint(selectedValue);
                          selectedRule = selectedValue as String;
                          selectedRuleIndex = tajweedRulesData.indexWhere(
                              (element) => element['type'] == selectedRule);
                          selectedApi =
                              tajweedRulesData[selectedRuleIndex!]['apilink'];
                        });
                      }),
                ),
              ),
              Card(
                child: Container(
                  height: size.height * 0.25,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedWord = tajweedRulesData[selectedRuleIndex!]
                                ['words'][index];
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: const EdgeInsets.all(9),
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                tajweedRulesData[selectedRuleIndex!]['words']
                                    [index],
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount:
                        tajweedRulesData[selectedRuleIndex!]['words'].length,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    vertical: kdefualtVerticalMargin),
                padding: const EdgeInsets.symmetric(
                    horizontal: kdefualtHorizontalPadding),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 179, 145),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Say the word below to check for selected tajweed rule",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      selectedWord == null ? '' : selectedWord!,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            isPressed = true;
                          });
                          debugPrint(selectedApi);
                          tajweedscore = await TajwedToScore.instance.record(
                              selectedApi!, user, selectedRuleIndex.toString());

                          setState(() {
                            isPressed = false;
                          });
                        },
                        icon: isPressed
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.mic),
                        label: isPressed
                            ? const Text("Stop")
                            : const Text("Start"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isPressed ? Colors.red : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      vertical: kdefualtVerticalMargin),
                  padding: const EdgeInsets.symmetric(
                      horizontal: kdefualtHorizontalPadding),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: tajweedscore != null
                      ? ListView.builder(
                          itemCount: tajweedscore!.data.length,
                          itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  tajweedscore!.data[index].label.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                FAProgressBar(
                                  animatedDuration:
                                      const Duration(milliseconds: 1000),
                                  maxValue: 100,
                                  currentValue:
                                      tajweedscore!.data[index].score * 100,
                                  displayText: '%',
                                  progressGradient: LinearGradient(
                                    colors: [
                                      kSecendoryColor.withOpacity(0.75),
                                      kBackgroundColor.withOpacity(0.75),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: Text('sss'))),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kdefualtVerticalPadding),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Word",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "To Practice tajweed recitation",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
