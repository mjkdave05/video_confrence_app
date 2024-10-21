import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;

  // Dark theme
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color.fromRGBO(14, 114, 236, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      cardColor: const Color.fromRGBO(46, 46, 46, 1),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color.fromRGBO(14, 114, 236, 1),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color.fromRGBO(14, 114, 236, 1), // Primary color for dark mode
        secondary: Color.fromRGBO(14, 114, 236, 1), // Accent color
        surfaceBright: Color.fromRGBO(36, 36, 36, 1), // Background color
        surface: Color.fromRGBO(46, 46, 46, 1), // Surface color for cards
      ),
    );
  }

  // Light theme
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromRGBO(14, 114, 236, 1),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.grey[100],
      buttonTheme: const ButtonThemeData(
        buttonColor: Color.fromRGBO(14, 114, 236, 1),
      ),
      colorScheme: const ColorScheme.light(
        primary:
            Color.fromRGBO(14, 114, 236, 1), // Primary color for light mode
        secondary: Color.fromRGBO(14, 114, 236, 1), // Accent color
        surfaceBright: Colors.white, // Background color
        surface: Color.fromRGBO(240, 240, 240, 1), // Surface color for cards
      ),
    );
  }

  // Getter for dark mode status
  bool get isDarkMode => _isDarkMode;

  // Toggle theme mode and notify listeners
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
