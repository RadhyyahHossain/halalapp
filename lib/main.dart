import 'package:flutter/material.dart';
import 'package:halalapp/screens/auth_screen.dart';
import 'package:halalapp/screens/details_page.dart';
import 'package:halalapp/screens/home_page.dart';
import 'package:halalapp/screens/map_screen.dart';
import 'package:halalapp/screens/onboarding_screen.dart';
import 'package:halalapp/screens/signup_page.dart';
import 'screens/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:halalapp/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/onboarding",
      routes: {
        "/login": (context) => AuthScreen(),
        "/home": (context) => HomeMainPage(),
        "/search": (context) => DetailsScreen(),
        "/map": (context) => mapScreen(),
        "/signup": (context) => signUpPage(
              showLoginPage: () {},
            ),
        "/onboarding": (context) => OnboardingScreen(),
      },
    );
  }
}
