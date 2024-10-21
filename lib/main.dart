import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_confrence_app/resources/auth_methods.dart';
import 'package:video_confrence_app/screens/home_screen.dart';
import 'package:video_confrence_app/screens/login_screen.dart';
import 'package:video_confrence_app/screens/onboarding.dart'; // Import your OnboardingScreen
import 'package:video_confrence_app/screens/video_call_screen.dart';
import 'package:video_confrence_app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/video-call': (context) => const VideoCallScreen(),
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
            return const HomeScreen();
          }

          // OnboardingScreen if the user is not authenticated
          return OnboardingScreen();
        },
      ),
    );
  }
}
