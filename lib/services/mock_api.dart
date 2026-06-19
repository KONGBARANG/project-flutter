import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class MockApiService {
  static const _asset = 'data/data_api.json';

  /// Loads and parses the mock data file. Returns the decoded JSON map.
  static Future<Map<String, dynamic>> loadMockData() async {
    final raw = await rootBundle.loadString(_asset);
    final data = json.decode(raw) as Map<String, dynamic>;
    return data;
  }

  /// Returns list of products from the mock data.
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final data = await loadMockData();
    final list = (data['products'] ?? []) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Returns single product by id or null.
  static Future<Map<String, dynamic>?> getProductById(int id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => (p['id'] ?? 0) == id);
    } catch (_) {
      return null;
    }
  }
}
