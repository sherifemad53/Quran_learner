import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart' as model;

import 'tajweed_data.dart';
import 'speech_to_text.dart';

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
  String? selectedWord;
  int? selectedRuleIndex = 0;

  model.User? user;

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
                          selectedRule = selectedValue as String;
                          selectedRuleIndex = tajweedRulesData.indexWhere(
                              (element) => element['type'] == selectedRule);
                        });
                      }),
                ),
              ),
              Card(
                child: Container(
                  height: size.height * 0.30,
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
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                tajweedRulesData[selectedRuleIndex!]['words']
                                    [index],
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            )
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
                height: MediaQuery.of(context).size.height * 0.30,
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

                          await SpeechToText.instance
                              .record(user, selectedRule!);

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
              //buttons to upload and edit
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
