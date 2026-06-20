import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  // ប្រើប្រាស់ _orders ជា private ដើម្បីការពារការកែប្រែផ្ទាល់ពីខាងក្រៅ
  final List<OrderItem> _orders = [];

  // Getter សម្រាប់ទាញយកបញ្ជីការបញ្ជាទិញ (ការពារការកែប្រែដោយប្រើ [...])
  List<OrderItem> get orders => [..._orders];

  // បន្ថែមការត្រួតពិនិត្យដើម្បីកុំឱ្យ add ចូលទទេ
  void addOrder(List<CartItem> cartProducts, double total) {
    if (cartProducts.isEmpty) return;

    // បង្កើត List ថ្មីពី cartProducts ដើម្បីការពារទិន្នន័យ (Deep Copy)
    final List<CartItem> orderItems = List.from(cartProducts);

    _orders.insert(
      0, 
      OrderItem(
        id: DateTime.now().toIso8601String(), // ប្រើ format នេះសម្រាប់ ID ដែលស្អាតជាង
        amount: total,
        products: orderItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners(); // ជូនដំណឹងដល់ UI ឱ្យ Update
  }

  // បន្ថែមមុខងារលុប Order មួយជាក់លាក់ (ជាជម្រើសបន្ថែម)
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}