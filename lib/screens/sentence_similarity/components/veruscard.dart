import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../../../constrains.dart';

class VerusCard extends StatelessWidget {
  const VerusCard({
    Key? key,
    this.label,
    this.confidance,
  }) : super(key: key);

  final String? label;
  final double? confidance;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Row(
            children: [
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.79,
                    child: AutoSizeText(
                      label.toString(),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    //fit: FlexFit.tight,
                    width: MediaQuery.of(context).size.width * 0.75,
                    //color: Colors.red,
                    child: FAProgressBar(
                      currentValue: confidance! * 100,
                      displayText: '%',
                      progressGradient: LinearGradient(
                        colors: [
                          kSecendoryColor.withOpacity(0.75),
                          kBackgroundColor.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
