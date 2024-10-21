import 'package:flutter/material.dart';

class PopupService {
  // Show a reusable snackbar popup
  static void showPopup(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError
          ? Colors.red
          : Colors.green, // Red for error, green for success
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2), // Popup duration
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
