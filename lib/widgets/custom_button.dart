import 'package:flutter/material.dart';
import 'package:video_confrence_app/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor, // Optional text color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: buttonColor), // Adjusted for border color
          ),
          elevation: 5, // Added elevation for a modern look
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: textColor ??
                Colors.white, // Use provided text color or default to white
          ),
        ),
      ),
    );
  }
}
