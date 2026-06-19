import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../main_wrapper/main_wrapper_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  // បន្ថែមប៉ារ៉ាម៉ែត្រទាំងពីរនេះដើម្បីទទួលតម្លៃបន្តពី main.dart
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AuthGate({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    if (auth.isLoggedIn) {
      // បោះតម្លៃ Dark Mode បន្តទៅឱ្យ MainWrapperScreen
      return MainWrapperScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
      );
    }
    
    return const LoginScreen();
  }
}