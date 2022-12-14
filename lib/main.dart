import 'package:flutter/material.dart';
import 'package:quran_leaner/constrains.dart';
import 'package:quran_leaner/screens/auth/auth_screen.dart';
import 'package:quran_leaner/screens/onboard_page/onboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //debugPrint('done-------');
    return MaterialApp(
      title: 'Quran Learner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        appBarTheme: AppBarTheme(color: kPrimaryColor),
        backgroundColor: kBackgroundColor,
      ),
      debugShowMaterialGrid: false,
      home: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 500) {
            return const OnboardScreen(); //AuthScreen();
          } else if (constrains.maxWidth > 500 && constrains.maxWidth < 1000) {
            return const OnboardScreen();
          } else {
            return const Scaffold(
              body: Center(child: Text('test')),
            );
          }
        },
      ),
    );
  }
}
