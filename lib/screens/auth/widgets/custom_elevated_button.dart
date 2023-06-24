import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.label,
    required this.size,
    required this.submit,
  }) : super(key: key);

  final Size size;
  final String label;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          foregroundColor: Colors.black,
        ),
        onPressed: () => submit(),
        child: Text(label),
      ),
    );
  }
}
