import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'welcome_image',
      child: Image(
        image: const AssetImage('assets/images/welcome_image.png'),
        width: size.width,
        height: size.height * 0.3,
        alignment: Alignment.center,
      ),
    );
  }
}
