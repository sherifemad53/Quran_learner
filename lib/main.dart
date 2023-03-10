import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/home_page/homapage_screen.dart';
import 'screens/surahview/surahview.dart';

import 'app_routes.dart';
import 'providers/user_provider.dart';
import 'common/constants.dart';
import 'theme/app_theme.dart';

//TODO Use state management system to provide user for all widgets
//IS firebase package enough for state management answer is no
//TODO Store user data in firestore and also in local store to be accessed faster
//TODO GETX BETTER THAN PROVIDER
//TODO READ QURAN FROM JSON FOR BETTER VIEWING

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: kAppTitle,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
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
          },
        ),
        routes: {
          AppRoutes.profile: (context) => const ProfileScreen(),
          //AppRoutes.aboutUs: (context) => const AboutUsScreen(),
          AppRoutes.welcome: (context) => const WelcomeScreen(),
          AppRoutes.surahView: (context) => const SurahViewScreen(),
          AppRoutes.signup: (context) => const SignupScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
        },
      ),
    ); //AuthScreen();
  }
}
