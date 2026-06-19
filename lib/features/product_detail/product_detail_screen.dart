import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. App Bar ដ៏ស្រស់ស្អាត
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.product.id,
                child: Image.network(widget.product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          
          // 2. ព័ត៌មានលម្អិត
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      Text('\$${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Rating
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(' ${widget.product.rating} | 1.2k Reviews', style: const TextStyle(color: Colors.grey)),
                  ]),
                  
                  const SizedBox(height: 20),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.product.description, style: TextStyle(color: Colors.grey[700], height: 1.6)),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 3. Bottom Action Bar (Quantity + Add to Cart)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)]),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => quantity > 1 ? quantity-- : null)),
                  Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => quantity++)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Add to Cart Button
            Expanded(
              child: FilledButton(
                onPressed: () {
                  for(int i=0; i<quantity; i++) cart.addToCart(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.translate('added_to_cart'))));
                },
                style: FilledButton.styleFrom(minimumSize: const Size(0, 55), backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(lang.translate('add_to_cart')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}