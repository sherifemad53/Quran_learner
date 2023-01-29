import 'package:flutter/material.dart';

import 'package:csv/csv.dart';

class QuranReaderScreen extends StatelessWidget {
  const QuranReaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blue,
          child: const Text('Quran'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Text('data'),
      ),
    );
  }
}
