import 'package:flutter/material.dart';
import 'package:quran_leaner/screens/about_us/aboutus.dart';
import 'package:quran_leaner/screens/speech_to_text/stt.dart';

//import '/constrains.dart';

import '/screens/home_page/homapage.dart';
import '/screens/quran_reader/quranreader.dart';
import '/screens/topic_modeling/topicmodeling.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            top: 40,
            right: 10,
          ),
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 30),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) {
                      return const HomePage();
                    }));
              },
            ),
            Divider(height: 1, thickness: 2, color: ThemeData().primaryColor),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text(
                'S E N T E N S E  S I M I L A R I T Y',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const TopicModelingScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(
                'Q U R A N',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const QuranReaderScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('STT'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const SpeechToTextScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('About US'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const AboutUsScreen();
                }));
              },
            ),
          ]),
        ),
      ),
    );
  }
}
