import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_confrence_app/resources/auth_methods.dart';
import 'package:video_confrence_app/screens/home_screen.dart';
import 'package:video_confrence_app/screens/login_screen.dart';
import 'package:video_confrence_app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase before running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conference App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
      },
      home: StreamBuilder(
        stream: AuthMethods().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // If the user is authenticated, navigate to HomeScreen
            return const HomeScreen();
          }

          // If no user is authenticated, show the LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
