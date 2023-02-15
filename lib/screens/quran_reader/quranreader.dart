import 'package:flutter/material.dart';

//TODO ALI EL SHIMMY TASK IMPLEMEENT QURAN READER OR PDF VIEWER WHICH VIEWS QURAN TO READ
//TODO SELECTABLE TEXT TO SEARCH FOR SIMILAR ONES USING OUR SEARCH ENGINE (SENSTENSE SIMILARITY)

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
