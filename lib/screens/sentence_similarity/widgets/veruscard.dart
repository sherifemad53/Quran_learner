import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../../../common/constants.dart';
import 'package:quranic_tool_box/services/senstence_Similarity_api_handler.dart';

class VerusCard extends StatefulWidget {
  const VerusCard(
      {Key? key,
      this.ayaText,
      this.surahName,
      this.similartyScore,
      this.ayaNum,
      this.surahNum})
      : super(key: key);

  final String? ayaText;
  final String? surahName;
  final int? ayaNum;
  final int? surahNum;
  final double? similartyScore;

  @override
  State<VerusCard> createState() => _VerusCardState();
}

class _VerusCardState extends State<VerusCard> {
  String tasferStr = '';
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        child: ListTile(
          onTap: () {
            setState(() {
              isPressed = !isPressed;
              // tasferStr = await
            });
          },
          title: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.surahName.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.79,
                child: AutoSizeText(
                  widget.ayaText.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  wrapWords: true,
                  minFontSize: 18,
                  maxFontSize: 30,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: FAProgressBar(
                  animatedDuration: const Duration(milliseconds: 1000),
                  maxValue: 100,
                  currentValue: widget.similartyScore! * 100,
                  displayText: '%',
                  progressGradient: LinearGradient(
                    colors: [
                      kSecendoryColor.withOpacity(0.75),
                      kBackgroundColor.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (isPressed)
                FutureBuilder(
                  future: tafserReadJson(
                      widget.surahName, widget.surahNum, widget.ayaNum),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else {
                      return Text(
                        snapshot.data!,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
