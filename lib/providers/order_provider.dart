import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  // ប្រើប្រាស់បញ្ជីឯកជនដើម្បីការពារទិន្នន័យពីការផ្លាស់ប្តូរដោយផ្ទាល់
  final List<OrderItem> _orders = [];

  // Getter ដើម្បីទាញយកបញ្ជីការកម្ម៉ង់ទាំងអស់
  List<OrderItem> get orders {
    return [..._orders];
  }

  // មុខងារសម្រាប់បន្ថែមការកម្ម៉ង់ថ្មី
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0, // បញ្ចូល order ថ្មីទៅខាងលើគេនៃបញ្ជី
      OrderItem(
        id: DateTime.now().toString(), // បង្កើត ID តាមពេលវេលាជាក់ស្តែង
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners(); // ជូនដំណឹងទៅ UI ឱ្យធ្វើការ Refresh
  }

  // មុខងារសម្រាប់លុបការកម្ម៉ង់ (ស្រេចចិត្ត - ប្រសិនបើអ្នកត្រូវការ)
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}