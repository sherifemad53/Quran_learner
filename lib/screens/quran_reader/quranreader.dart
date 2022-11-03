import 'package:flutter/material.dart';

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
      body: const Center(child: Text('hello')),
    );
  }
}
