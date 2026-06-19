import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';

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

  // បន្ថែម Controller សម្រាប់ព័ត៌មានកាត
  final _cardC = TextEditingController();
  final _expiryC = TextEditingController();
  final _cvvC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    _cardC.dispose();
    _expiryC.dispose();
    _cvvC.dispose();
    super.dispose();
  }

  // មុខងារសម្រាប់បើក Dialog បំពេញកាត
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Card Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _cardC, decoration: const InputDecoration(labelText: 'Card Number')),
            TextField(controller: _expiryC, decoration: const InputDecoration(labelText: 'Expiry Date')),
            TextField(controller: _cvvC, decoration: const InputDecoration(labelText: 'CVV')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card details saved!')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Information', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              CustomTextField(controller: _nameC, label: 'Full Name'),
              const SizedBox(height: 12),
              CustomTextField(controller: _emailC, label: 'Email'),
              const SizedBox(height: 12),
              CustomTextField(controller: _phoneC, label: 'Phone Number'),
              const SizedBox(height: 12),
              CustomTextField(controller: _addressC, label: 'Delivery Address'),
              const SizedBox(height: 24),
              
              Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              // Container ដែលអាចចុចបាន
              InkWell(
                onTap: _showPaymentDialog,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.deepPurple),
                      SizedBox(width: 12),
                      Text('Credit Card (Tap to edit)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Builder(builder: (context) {
                final langProvider = Provider.of<LanguageProvider>(context);
                final cartProvider = Provider.of<CartProvider>(context, listen: false);

                return FilledButton.icon(
                  onPressed: () {
                    if (_nameC.text.isEmpty || _emailC.text.isEmpty || _phoneC.text.isEmpty || _addressC.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(langProvider.translate('please_fill_all_fields'))),
                      );
                      return;
                    }
                    
                    // ពិនិត្យថាតើបានបំពេញកាតដែរឬនៅ
                    if (_cardC.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter card details first')));
                      return;
                    }

                    cartProvider.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${langProvider.translate('order_placed_for')} ${_nameC.text}')),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(langProvider.translate('place_order'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
