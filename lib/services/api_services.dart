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

  // ១. ទាញផលិតផលទាំងអស់ (កែឱ្យឡើង ៤០ មុខ)
  static Future<List<Product>> getProducts() async {
    final uri = Uri.parse('$_storeUrl/products');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      final List<Product> originalProducts = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      final List<Product> expandedProducts = [...originalProducts];
      expandedProducts.addAll(_buildProductVariants(originalProducts, 3, 'Edition', 1000));
      return expandedProducts;
    }
    throw Exception('Failed to load products');
  }

  // ២. ទាញផលិតផលតាមប្រភេទទំនិញ
  static Future<List<Product>> getProductsByCategory(String category) async {
    final uri = Uri.parse('$_storeUrl/products/category/$category');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      final List<Product> originalProducts = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      final List<Product> expandedProducts = [...originalProducts];
      expandedProducts.addAll(_buildProductVariants(originalProducts, 2, 'Filtered Edition', 2000));
      return expandedProducts;
    }
    throw Exception('Failed to load products');
  }

  static List<Product> _buildProductVariants(List<Product> products, int sets, String suffix, int idOffset) {
    final duplicates = <Product>[];
    for (var i = 1; i <= sets; i++) {
      final priceMultiplier = 1 + (0.06 * i);
      final ratingIncrease = 0.15 * i;
      for (var product in products) {
        duplicates.add(
          Product(
            id: product.id + (idOffset * i),
            title: '${product.title} - $suffix ${i + 1}',
            price: ((product.price * priceMultiplier) * 100).round() / 100,
            description: '${product.description} This is a $suffix with a refreshed look.',
            category: product.category,
            image: product.image,
            rating: (product.rating + ratingIncrease).clamp(0, 5),
          ),
        );
      }
    }
    return duplicates;
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