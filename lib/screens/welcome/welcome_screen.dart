import 'package:flutter/material.dart';
import '/app_routes.dart';

import '../../common/constants.dart';

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
            image: const AssetImage(kWelcomeImagePath),
            width: size.width,
            height: size.height * 0.5,
            alignment: Alignment.center,
          ),
        ),
        kSizedBox,
        Padding(
          padding: const EdgeInsets.all(kdefualtPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                kAppTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                kWelcomeSubtitle,
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
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.signup),
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    foregroundColor: Colors.black),
                child: Text(kSignup.toUpperCase()),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              child: TextButton(
                style: TextButton.styleFrom(
                    //foregroundColor: Colors.blueGrey,
                    splashFactory: NoSplash.splashFactory),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.login),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: kAlreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(text: kLogin.toUpperCase()),
                ])),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
