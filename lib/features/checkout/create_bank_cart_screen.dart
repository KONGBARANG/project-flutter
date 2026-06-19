import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart'; // កែតម្រូវ Import ឱ្យត្រូវ
import '../../models/cart_model.dart'; 

class CreateBankCardScreen extends StatefulWidget {
  const CreateBankCardScreen({super.key});

  @override
  State<CreateBankCardScreen> createState() => _CreateBankCardScreenState();
}

class _CreateBankCardScreenState extends State<CreateBankCardScreen> {
  final _cardNumberC = TextEditingController();
  final _cardHolderC = TextEditingController();
  final _expiryC = TextEditingController();

  @override
  void dispose() {
    _cardNumberC.dispose();
    _cardHolderC.dispose();
    _expiryC.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (_cardNumberC.text.isEmpty || _cardHolderC.text.isEmpty || _expiryC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newCard = CardModel(
      id: DateTime.now().toString(),
      cardNumber: _cardNumberC.text,
      cardHolder: _cardHolderC.text,
      expiry: _expiryC.text,
    );

    // ប្តូរមកហៅ CartProvider វិញ ព្រោះមុខងារកាតស្ថិតក្នុងនេះ
    Provider.of<CartProvider>(context, listen: false).addCard(newCard);
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Card')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cardNumberC,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardHolderC,
              decoration: const InputDecoration(labelText: 'Card Holder Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _expiryC,
              decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveCard,
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Save Card'),
            ),
          ],
        ),
      ),
    );
  }
}