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

  /// Loads the user login list from app documents if present, otherwise copies
  /// from the bundled asset and returns it. Always returns a List of maps.
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

      // Handle both old array format and new database format
      final decoded = json.decode(content);
      List<dynamic> data;
      
      if (decoded is List) {
        // Legacy format: direct array
        data = decoded;
      } else if (decoded is Map && decoded['users'] != null) {
        // New format: { "users": [...], "metadata": {...} }
        data = decoded['users'] as List<dynamic>;
      } else {
        data = [];
      }
      
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Validate login against stored users. Returns the user map if matched.
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

  /// Adds a new user to the local store. Overwrites if same email exists.
  /// Automatically updates metadata (totalUsers and lastUpdated).
  static Future<void> addOrUpdateUser(Map<String, dynamic> user) async {
    try {
      final local = await _localFile();
      String content = '{"users":[], "metadata":{"version":"1.0","lastUpdated":"","totalUsers":0}}';
      
      if (await local.exists()) {
        final existing = await local.readAsString();
        if (existing.trim().isNotEmpty) {
          content = existing;
        }
      }
      
      final decoded = json.decode(content);
      List<Map<String, dynamic>> users = [];
      
      // Extract users array
      if (decoded is Map && decoded['users'] != null) {
        users = (decoded['users'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } else if (decoded is List) {
        users = decoded
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      
      // Add or update user with timestamp
      final idx = users.indexWhere((u) => (u['email'] ?? '') == (user['email'] ?? ''));
      final userWithTimestamp = {...user};
      
      if (idx >= 0) {
        userWithTimestamp['lastLoginDate'] = DateTime.now().toIso8601String();
        users[idx] = userWithTimestamp;
      } else {
        userWithTimestamp['id'] = (users.isNotEmpty ? users.map((u) => u['id'] as int? ?? 0).reduce((a, b) => a > b ? a : b) : 0) + 1;
        userWithTimestamp['registrationDate'] = userWithTimestamp['registrationDate'] ?? DateTime.now().toIso8601String();
        userWithTimestamp['isActive'] = userWithTimestamp['isActive'] ?? true;
        users.add(userWithTimestamp);
      }
      
      // Build the database object with metadata
      final dbObject = {
        'users': users,
        'metadata': {
          'version': '1.0',
          'lastUpdated': DateTime.now().toIso8601String(),
          'totalUsers': users.length,
        }
      };
      
      await local.writeAsString(json.encode(dbObject));
    } catch (e) {
      // Fallback: save as is
    }
  }
}
