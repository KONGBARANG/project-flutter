import 'package:flutter/material.dart';
import '../services/local_data_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;

  void login(String email) {
    _isLoggedIn = true;
    _email = email;
    notifyListeners();
  }

  /// Try to login using local data store (data/userlogin.json).
  /// Returns true if login successful.
  Future<bool> loginWithLocal(String email, String password) async {
    final user = await LocalDataService.validateLogin(email, password);
    if (user != null) {
      login(user['email']?.toString() ?? email);
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    notifyListeners();
  }
}
