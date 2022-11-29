import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quran_leaner/screens/home_page/homapage.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/rm194-aew-13.jpg'),
              fit: BoxFit.fill,
            ),
            //backgroundBlendMode: BlendMode.color,
          ),
        ),
        SafeArea(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                  title: "Title of first page",
                  body:
                      "Here you can write the description of the page, to explain someting...",
                  image: const Center(
                    child: Image(
                        image: AssetImage('assets/images/rm194-aew-13.jpg'),
                        height: 170),
                  ),
                  decoration: const PageDecoration(pageColor: Colors.grey)),
              PageViewModel(
                title: "Title of first page",
                body:
                    "Here you can write the description of the page, to explain someting...",
                decoration: const PageDecoration(pageColor: Colors.grey),
              )
            ],
            done: const Text('Get Started',
                style: TextStyle(fontWeight: FontWeight.w600)),
            onDone: () => goToHome(context),
            showSkipButton: true,
            skip: const Text('Skip'),
            onSkip: () => goToHome(context),
            next: const Icon(Icons.arrow_forward),
            dotsDecorator: getDotDecoration(),
            onChange: (index) => debugPrint('Page $index selected'),
            globalBackgroundColor: Theme.of(context).backgroundColor,
            nextFlex: 0,
          ),
        ),
      ],
    );
  }

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: const Color.fromARGB(255, 9, 8, 8),
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle:
            const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: const TextStyle(fontSize: 20),
        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
