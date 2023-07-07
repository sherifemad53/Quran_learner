import 'package:flutter/material.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  final String _version = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Quranic Tool Box (QTB)",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.018),
          ),
          Text(
            "Version: $_version\n",
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.015),
          )
        ],
      ),
    );
  }
}
