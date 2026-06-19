import 'package:flutter/foundation.dart'; // ប្រើសម្រាប់ @immutable ឬ logic ផ្សេងៗ
import 'cart_item.dart'; // ត្រូវប្រាកដថា import នេះត្រឹមត្រូវតាម Path នៃឯកសារ cart_item.dart របស់អ្នក

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products; 
  final DateTime dateTime;

  OrderItem({
    required this.id, 
    required this.amount, 
    required this.products, 
    required this.dateTime,
  });
}