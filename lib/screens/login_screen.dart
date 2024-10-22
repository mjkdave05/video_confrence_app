import 'package:flutter/material.dart';
import 'package:video_confrence_app/resources/auth_methods.dart';
import 'package:video_confrence_app/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                "Start or join a meeting",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30), // Space between title and image

              // Circular image with glass effect
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150), // Circular border
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 4),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2), // Glass effect color
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Padding around the image
                    child: Image.asset(
                      'assets/images/meeting.png',
                      height: 200, // Smaller height for the image
                      fit: BoxFit.cover, // Cover the circular area
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Space between image and button

              // Custom Button
              CustomButton(
                text: "Google Sign In",
                onPressed: () async {
                  bool res = await _authMethods.signInWithGoogle(context);
                  if (res) {
                    Navigator.pushNamed(context, "/home");
                  }
                },
                textColor: Colors.white, // Set text color for button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
