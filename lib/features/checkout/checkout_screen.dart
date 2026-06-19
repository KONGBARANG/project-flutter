import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_textfield.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
// ត្រូវប្រាកដថាបាន Import ឯកសារនេះត្រឹមត្រូវ
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

  // អថេរសម្រាប់រក្សាលេខកាតដែលជ្រើសរើស
  String? _selectedCard;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    super.dispose();
  }

  // មុខងារសម្រាប់បើក BankCardsScreen
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

              // Container សម្រាប់ជ្រើសរើសកាត
              InkWell(
                onTap: _navigateToBankCards,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: _selectedCard != null ? Colors.deepPurple : Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedCard ?? 'Select a Payment Method',
                          style: TextStyle(
                            color: _selectedCard != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
                    
                    // ពិនិត្យថាតើបានជ្រើសរើសកាតដែរឬនៅ
                    if (_selectedCard == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a payment card first!')),
                      );
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
                  label: Text(
                    langProvider.translate('place_order'), 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}