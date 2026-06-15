import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // អនុគមន៍សម្រាប់ប្តូរ Light/Dark Mode
  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners(); // ផ្ញើសញ្ញាទៅប្រាប់កម្មវិធីឱ្យប្តូរពណ៌ភ្លាមៗ
  }

  // កំណត់ពណ៌សម្រាប់ Light Theme (ម៉ូតភ្លឺ)
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // កំណត់ពណ៌សម្រាប់ Dark Theme (ម៉ូតងងឹត)
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212), // ពណ៌ខ្មៅស្រទន់បែប Premium
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}