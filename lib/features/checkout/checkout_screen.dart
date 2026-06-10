import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

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

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    super.dispose();
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
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(width: 12),
                    Text('Credit Card (Demo)'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              CustomButton(
                label: 'Place Order',
                onPressed: () {
                  if (_nameC.text.isEmpty || _emailC.text.isEmpty || _phoneC.text.isEmpty || _addressC.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order placed for ${_nameC.text}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
