import 'package:flutter/material.dart';

class _OnBoardingPage extends StatelessWidget {
  final String image;
  final String text;
  const _OnBoardingPage({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}
