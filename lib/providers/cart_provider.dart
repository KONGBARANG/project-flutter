import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/cart_model.dart'; 

class CartProvider extends ChangeNotifier {
  // --- ផ្នែក Cart ---
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items); // ប្រើ unmodifiable ដើម្បីសុវត្ថិភាពទិន្នន័យ

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get itemCount => _items.length;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) { // ពិនិត្យមើលថារកឃើញ item មែនទេ
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // --- ផ្នែក Card ---
  final List<CardModel> _cards = [];
  List<CardModel> get cards => List.unmodifiable(_cards); // បន្ថែម unmodifiable ផងដែរ

  void addCard(CardModel card) {
    // បន្ថែមការការពារ៖ កុំឱ្យបន្ថែមទិន្នន័យទទេ
    if (card.cardNumber.isEmpty) return; 
    _cards.add(card);
    notifyListeners();
  }
}