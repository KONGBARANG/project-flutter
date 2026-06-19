import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ហៅទិន្នន័យពី OrderProvider
    final orderData = Provider.of<OrderProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: orderData.orders.isEmpty 
        ? const Center(child: Text("No orders placed yet."))
        : ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) {
              final order = orderData.orders[i];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  // បង្ហាញតម្លៃសរុបនៃ Order
                  title: Text('\$${order.amount.toStringAsFixed(2)}'),
                  // បង្ហាញកាលបរិច្ឆេទ
                  subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
                  children: order.products.map((prod) => ListTile(
                    title: Text(prod.product.title), // ហៅតាម prod.product.title
                    trailing: Text(
                      '${prod.quantity}x \$${(prod.product.price * prod.quantity).toStringAsFixed(2)}'
                    ),
                  )).toList(),
                ),
              );
            },
          ),
    );
  }
}