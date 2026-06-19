import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'create_bank_cart_screen.dart';

class BankCardsScreen extends StatefulWidget {
  const BankCardsScreen({super.key});

  @override
  State<BankCardsScreen> createState() => _BankCardsScreenState();
}

class _BankCardsScreenState extends State<BankCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Cards')),
      // ត្រូវប្រាកដថាប្រើ Consumer<CartProvider>
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          // ប្រើឈ្មោះ cartProvider ដែលជាឈ្មោះ parameter ត្រឹមត្រូវ
          if (cartProvider.cards.isEmpty) {
            return const Center(
              child: Text('No cards found. Tap + to add.'),
            );
          }
          
          return ListView.builder(
            itemCount: cartProvider.cards.length,
            itemBuilder: (context, index) {
              final card = cartProvider.cards[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.credit_card, color: Colors.deepPurple),
                  title: Text(card.cardNumber),
                  subtitle: Text(card.cardHolder),
                  onTap: () {
                    Navigator.pop(context, card.cardNumber);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBankCardScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}