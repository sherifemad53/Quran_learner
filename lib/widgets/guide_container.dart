import 'package:flutter/material.dart';

class GuideContainer extends StatelessWidget {
  final String title;
  final String guideDescription;
  final int guideNo;

  const GuideContainer(
      {Key? key,
      required this.guideNo,
      required this.title,
      required this.guideDescription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Text(
            "\n$guideNo. $title",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(guideDescription,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
