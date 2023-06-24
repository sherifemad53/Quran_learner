import 'package:flutter/material.dart';

import '../../common/constants.dart';

class TajweedCorrectionScreen extends StatefulWidget {
  const TajweedCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<TajweedCorrectionScreen> createState() =>
      _TajweedCorrectionScreenState();
}

class _TajweedCorrectionScreenState extends State<TajweedCorrectionScreen> {
  List<String> arabicWords = ['التل', 'مائة', 'تواصل', 'جعل', 'منذ', 'طائر'];
  String selectedWord = '';

  final isSelected = false;
  bool isRecording = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                  height: size.height * 0.30,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(arabicWords[index]),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: arabicWords.length,
                  ),
                ),
              ),
              //this container shows the wrong words and their correnction
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
                child: const Center(child: CircularProgressIndicator()),
              ),
              //buttons to upload and edit
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => isPressed = !isPressed),
                  icon: isPressed
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.mic),
                  label: isPressed ? const Text("Stop") : const Text("Start"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isPressed ? Colors.red : Colors.grey),
                ),
              )
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
