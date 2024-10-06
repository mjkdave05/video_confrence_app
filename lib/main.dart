import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'utils/colors.dart';

void main() {
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
      },

      home: const LoginScreen(),
    );
  }
}

