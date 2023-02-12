import 'package:flutter/material.dart';

import 'package:quran_leaner/constrains.dart';
import 'package:quran_leaner/screens/home_page/homapage.dart';
import 'package:quran_leaner/screens/onboard_page/onboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quran_leaner/screens/welcome/welcome_screen.dart';
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
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
        useMaterial3: true,
        backgroundColor: kBackgroundColor,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Colors.white12),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.black)),
        //TODO: all texttheme styles
        textTheme: const TextTheme(
          displaySmall: TextStyle(fontSize: 20),
          displayMedium: TextStyle(fontSize: 20),
          displayLarge: TextStyle(fontSize: 20),
          headlineSmall: TextStyle(fontSize: 21),
          headlineMedium: TextStyle(fontSize: 24),
          headlineLarge: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 18),
          bodyLarge: TextStyle(fontSize: 20),
          labelSmall: TextStyle(fontSize: 20),
          labelMedium: TextStyle(fontSize: 20),
          labelLarge: TextStyle(fontSize: 20),
          titleSmall: TextStyle(fontSize: 20),
          titleMedium: TextStyle(fontSize: 20),
          titleLarge: TextStyle(fontSize: 20),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.black12,
        appBarTheme: const AppBarTheme(color: Colors.purple, elevation: 0),
        useMaterial3: true,
        backgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 20),
          displayMedium: TextStyle(fontSize: 20),
          displaySmall: TextStyle(fontSize: 20),
          headlineLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20),
          headlineSmall: TextStyle(fontSize: 20),
          bodySmall: TextStyle(fontSize: 20),
          bodyLarge: TextStyle(fontSize: 22),
          bodyMedium: TextStyle(fontSize: 18),
          labelLarge: TextStyle(fontSize: 20),
          labelMedium: TextStyle(fontSize: 20),
          labelSmall: TextStyle(fontSize: 20),
          titleLarge: TextStyle(fontSize: 20),
          titleMedium: TextStyle(fontSize: 20),
          titleSmall: TextStyle(fontSize: 20),
        ),
      ),
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
