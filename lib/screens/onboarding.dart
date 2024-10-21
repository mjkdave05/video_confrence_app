import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'login_screen.dart'; // Import your LoginScreen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _firstTextAnimation;
  late Animation<Offset> _secondTextAnimation;
  bool _showSecondText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // First text slides from bottom to center
    _firstTextAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts below the screen
      end: Offset.zero, // Ends at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Second text slides from bottom to center
    _secondTextAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts below the screen
      end: Offset.zero, // Ends at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the first animation after a short delay
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showSecondText = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          _navigateToLogin();
        });
      });
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/slide_img.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Animated texts
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _firstTextAnimation,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'ZIDIO',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_showSecondText) // Only show the second text after delay
                  SlideTransition(
                    position: _secondTextAnimation,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Welcome to Zidio, your video conferencing solution.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
