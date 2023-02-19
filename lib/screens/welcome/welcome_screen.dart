import 'package:flutter/material.dart';
import 'package:quran_leaner/screens/auth/auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Hero(
          tag: 'welcome_image',
          child: Image(
            image: const AssetImage('assets/images/welcome_image.png'),
            width: size.width,
            height: size.height * 0.5,
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Quranic tool box',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Our main goal starting this project is to help people learn Quran easily.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: size.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) {
                        return AuthScreen(
                          islogin: false,
                        );
                      }));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    foregroundColor: Colors.black),
                child: Text("signup".toUpperCase()),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    splashFactory: NoSplash.splashFactory),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      //fullscreenDialog: true,
                      builder: (_) {
                    return AuthScreen(
                      islogin: true,
                    );
                  }));
                },
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Already have an account?',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(text: ' login'.toUpperCase()),
                ])),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
