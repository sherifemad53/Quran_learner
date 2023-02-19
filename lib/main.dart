import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_options.dart';

import 'screens/home_page/homapage.dart';
import 'screens/welcome/welcome_screen.dart';
import 'theme/app_theme.dart';

//TODO Use state management system to provide user for all widgets
//IS firebase package enough for state management
//TODO Store user data in firestore and also in local store to be accessed faster

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
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.active) {
              if (userSnapshot.hasData) {
                return const HomePage();
              } else if (userSnapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(userSnapshot.error.toString()),
                  backgroundColor: Colors.red,
                ));
              } else {}
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return const WelcomeScreen();
            //else if (userSnapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(
            //     child: CircularProgressIndicator.adaptive(),
            //   );
            // }
            //intro screen with authform
          }),
    ); //AuthScreen();
  }
}
