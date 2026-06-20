import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/order_provider.dart'; // ១. ត្រូវ Import OrderProvider
import 'bank_cart_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _addressC = TextEditingController();
  String? _selectedCard;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    super.dispose();
  }

  Future<void> _navigateToBankCards() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BankCardsScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        _selectedCard = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ប្រើ Consumer ឬ Provider.of ដើម្បីទាញយកទិន្នន័យចាំបាច់
    final langProvider = Provider.of<LanguageProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false); // ២. ហៅប្រើ OrderProvider

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _nameC, label: 'Full Name'),
            const SizedBox(height: 12),
            CustomTextField(controller: _emailC, label: 'Email'),
            const SizedBox(height: 12),
            CustomTextField(controller: _phoneC, label: 'Phone Number'),
            const SizedBox(height: 12),
            CustomTextField(controller: _addressC, label: 'Delivery Address'),
            const SizedBox(height: 24),

            // Payment Section
            InkWell(
              onTap: _navigateToBankCards,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.credit_card),
                    const SizedBox(width: 12),
                    Text(_selectedCard ?? 'Select a Payment Method'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                if (_nameC.text.isEmpty || _addressC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(langProvider.translate('please_fill_all_fields'))));
                  return;
                }
                if (_selectedCard == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a payment card!')));
                  return;
                }

                // ៣. បញ្ជូនទិន្នន័យទៅក្នុង Memory (OrderProvider)
                orderProvider.addOrder(
                  cartProvider.items, 
                  cartProvider.totalPrice
                );

                // ៤. លុបកន្ត្រកចោល
                cartProvider.clearCart();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(langProvider.translate('order_placed_for') + " " + _nameC.text)),
                );

                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              icon: const Icon(Icons.check),
              label: Text(langProvider.translate('place_order')),
            ),
          ],
        ),
      ),
    );
  }
}