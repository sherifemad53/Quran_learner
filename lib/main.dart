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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Learner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(color: Colors.green[700]),
        backgroundColor: kBackgroundColor,
      ),
      debugShowMaterialGrid: false,
      home: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 500) {
            return const AuthScreen(); //AuthScreen();
          } else if (constrains.maxWidth > 500 && constrains.maxWidth < 1000) {
            return const OnboardScreen();
          } else {
            return const Center(
              child: Text("hello"),
            );
          }
        },
      ),
    );
  }
}
