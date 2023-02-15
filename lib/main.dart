import 'package:flutter/material.dart';

import 'package:quran_leaner/screens/home_page/homapage.dart';
import 'package:quran_leaner/screens/onboard_page/onboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quran_leaner/screens/welcome/welcome_screen.dart';
import 'theme/app_theme.dart';
//import 'package:firebase_core/firebase_options.dart';

//TODO Use state management system to provide user for all widgets
//IS firebase package enough for state management

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
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowMaterialGrid: false,
      home: LayoutBuilder(
        builder: (context, constrains) {
          if (constrains.maxWidth < 500) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: ((context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return const HomePage();
                  } else if (userSnapshot.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(userSnapshot.error.toString()),
                      backgroundColor: Colors.red,
                    ));
                  } else if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  //intro screen with authform
                  return const WelcomeScreen();
                })); //AuthScreen();
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
