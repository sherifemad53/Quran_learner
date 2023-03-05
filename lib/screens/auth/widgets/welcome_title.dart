import 'package:flutter/material.dart';

class WelcomeTitle extends StatelessWidget {
  const WelcomeTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome,',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          'Create an account to start learning',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}