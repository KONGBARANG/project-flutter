import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              color: Colors.grey[200],
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  
                  // Rating and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(product.category, style: const TextStyle(color: Colors.blue)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 32),
                  
                  // Add to cart button
                  CustomButton(
                    label: 'Add to Cart',
                    onPressed: () {
                      // For demo purposes, we'll show a simple notification
                      // In a real app, you'd use Provider to access CartProvider
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
