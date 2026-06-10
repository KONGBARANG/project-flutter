import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiServices {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const _storeUrl = 'https://fakestoreapi.com';

  static Future<Map<String, dynamic>> testGetPosts() async {
    final uri = Uri.parse('$_baseUrl/posts/1');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load');
  }

  // Fetch all products
  static Future<List<Product>> getProducts() async {
    final uri = Uri.parse('$_storeUrl/products');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load products');
  }

  // Fetch single product
  static Future<Product> getProductById(int id) async {
    final uri = Uri.parse('$_storeUrl/products/$id');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      return Product.fromJson(json.decode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to load product');
  }

  // Fetch products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    final uri = Uri.parse('$_storeUrl/products/category/$category');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load products');
  }

  // Get all categories
  static Future<List<String>> getCategories() async {
    final uri = Uri.parse('$_storeUrl/products/categories');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((item) => item.toString()).toList();
    }
    throw Exception('Failed to load categories');
  }
}
