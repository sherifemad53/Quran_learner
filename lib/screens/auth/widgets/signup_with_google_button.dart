import 'package:flutter/material.dart';

class SignupWithGoogleButton extends StatelessWidget {
  const SignupWithGoogleButton({
    Key? key,
    required this.size,
    required this.submit,
  }) : super(key: key);

  final Size size;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: OutlinedButton.icon(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            foregroundColor: Colors.black),
        onPressed: () => submit(),
        label: const Text('Sign up with Google'),
        icon: const Image(
          image: AssetImage('assets/icons/google_icon.png'),
          width: 30,
        ),
      ),
    );
  }
}
