import 'package:flutter/material.dart';

class BasmallahBar extends StatelessWidget {
  const BasmallahBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        child: const Text(
          'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
          style: TextStyle(fontFamily: '110_Besmellah_Normal', fontSize: 30),
        ),
      ),
    );
  }
}
