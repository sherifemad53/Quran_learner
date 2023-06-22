import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({Key? key, required this.width, required this.height})
      : super(key: key);

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'welcome_image',
      child: Image(
        image: const AssetImage('assets/images/welcome_image.png'),
        width: width,
        height: height,
        alignment: Alignment.center,
      ),
    );
  }
}
