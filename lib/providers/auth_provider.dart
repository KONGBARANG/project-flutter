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

  /// ផ្ទៀងផ្ទាត់ការ Login ដោយអានចេញពី Local File
  Future<bool> loginWithLocal(String email, String password) async {
    final user = await LocalDataService.validateLogin(email, password);
    if (user != null) {
      login(user['email']?.toString() ?? email);
      return true;
    }
    return false;
  }

  /// 🔥 មុខងារផ្លាស់ប្តូរលេខកូដសម្ងាត់
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_email == null) {
      throw Exception("មិនទាន់មានគណនី Login នៅក្នុងប្រព័ន្ធនៅឡើយទេ!");
    }

    // ១. ផ្ទៀងផ្ទាត់លេខកូដចាស់ពី Local File ជាក់ស្តែង
    final user = await LocalDataService.validateLogin(_email!, currentPassword);
    
    if (user == null) {
      throw Exception("លេខកូដសម្ងាត់បច្ចុប្បន្នមិនត្រឹមត្រូវទេ!");
    }

    try {
      // ២. ធ្វើបច្ចុប្បន្នភាព និងរក្សាទុកចូលទៅក្នុង Local File របស់ម៉ាស៊ីន
      await LocalDataService.updatePassword(_email!, newPassword);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception("មានបញ្ហាក្នុងការផ្លាស់ប្តូរលេខកូដ៖ $e");
    }
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    notifyListeners();
  }
}