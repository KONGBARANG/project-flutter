import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              // Cart items list
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemCard(
                      item: item,
                      onQuantityChanged: (newQuantity) {
                        // កែសម្រួល Logic: បើចំនួនតិចជាងឬស្មើ 0 ឱ្យលុបចេញ
                        if (newQuantity <= 0) {
                          cart.removeFromCart(item.product.id);
                        } else {
                          cart.updateQuantity(item.product.id, newQuantity);
                        }
                      },
                      onRemove: () {
                        cart.removeFromCart(item.product.id);
                      },
                    );
                  },
                ),
              ),

              const Divider(),

              // Total and checkout section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Checkout Button
                    Consumer<LanguageProvider>(
                      builder: (context, lang, child) {
                        return FilledButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF673AB7),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lang.translate('proceed_to_checkout'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                item.product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image),
              ),
            ),
            const SizedBox(width: 12),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title, 
                       maxLines: 2, 
                       overflow: TextOverflow.ellipsis, 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${item.product.price.toStringAsFixed(2)}', 
                       style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => onQuantityChanged(item.quantity - 1),
                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                        padding: EdgeInsets.zero,
                      ),
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => onQuantityChanged(item.quantity + 1),
                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}