import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class LocalDataService {
  static const _assetPath = 'data/userlogin.json';

  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/userlogin.json');
  }

  /// អានបញ្ជីឈ្មោះអ្នកប្រើប្រាស់ពីឯកសារ Local របស់ឧបករណ៍
  static Future<List<Map<String, dynamic>>> loadUserLogins() async {
    try {
      final local = await _localFile();
      String content;
      if (await local.exists()) {
        content = await local.readAsString();
        if (content.trim().isEmpty) content = '{"users":[]}';
      } else {
        content = await rootBundle.loadString(_assetPath);
        if (content.trim().isEmpty) content = '{"users":[]}';
        await local.writeAsString(content);
      }

      final decoded = json.decode(content);
      List<dynamic> data;
      
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded['users'] != null) {
        data = decoded['users'] as List<dynamic>;
      } else {
        data = [];
      }
      
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// ផ្ទៀងផ្ទាត់ការ Login
  static Future<Map<String, dynamic>?> validateLogin(String email, String password) async {
    final users = await loadUserLogins();
    try {
      for (final u in users) {
        final uEmail = (u['email'] ?? '').toString();
        final uPass = (u['password'] ?? '').toString();
        if (uEmail == email && uPass == password) return u;
      }
    } catch (_) {}
    return null;
  }

  /// 🛠️ មុខងារសម្រាប់ធ្វើបច្ចុប្បន្នភាពលេខកូដសម្ងាត់ថ្មី
  static Future<void> updatePassword(String email, String newPassword) async {
    try {
      final List<Map<String, dynamic>> users = await loadUserLogins();
      final idx = users.indexWhere((u) => (u['email'] ?? '').toString() == email);

      if (idx >= 0) {
        final updatedUser = Map<String, dynamic>.from(users[idx]);
        updatedUser['password'] = newPassword;
        updatedUser['lastLoginDate'] = DateTime.now().toIso8601String();
        users[idx] = updatedUser;
      } else {
        throw Exception("រកមិនឃើញគណនីរបស់អ្នកនៅក្នុងប្រព័ន្ធទេ!");
      }

      await _saveToLocalFile(users);
    } catch (e) {
      throw Exception("មិនអាចផ្លាស់ប្តូរលេខកូដសម្ងាត់បានទេ៖ $e");
    }
  }

  /// 🔥 មុខងារបន្ថែម ឬធ្វើបច្ចុប្បន្នភាពទិន្នន័យ User (ជួសជុលសម្រាប់ផ្ទាំង Login)
  static Future<void> addOrUpdateUser(Map<String, dynamic> updatedUser) async {
    try {
      final List<Map<String, dynamic>> users = await loadUserLogins();
      final email = (updatedUser['email'] ?? '').toString();
      final idx = users.indexWhere((u) => (u['email'] ?? '').toString() == email);

      if (idx >= 0) {
        // បើមាន User ស្រាប់ (ករណី Login រួចធ្វើបច្ចុប្បន្នភាពថ្ងៃខែ)
        users[idx] = Map<String, dynamic>.from(updatedUser);
      } else {
        // បើជា User ថ្មី (ករណី Register គណនីថ្មី)
        users.add(Map<String, dynamic>.from(updatedUser));
      }

      await _saveToLocalFile(users);
    } catch (e) {
      throw Exception("មិនអាចរក្សាទុកទិន្នន័យអ្នកប្រើប្រាស់បានទេ៖ $e");
    }
  }

  /// 📦 មុខងារជំនួយសម្រាប់សរសេរទិន្នន័យចូល File (ជៀសវាងការសរសេរកូដជាន់គ្នា)
  static Future<void> _saveToLocalFile(List<Map<String, dynamic>> users) async {
    final dbObject = {
      'users': users,
      'metadata': {
        'version': '1.0',
        'lastUpdated': DateTime.now().toIso8601String(),
        'totalUsers': users.length,
      }
    };
    final local = await _localFile();
    await local.writeAsString(json.encode(dbObject));
  }
}