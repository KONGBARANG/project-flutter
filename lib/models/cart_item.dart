import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product, 
    this.quantity = 1,
  });

  // បន្ថែម method នេះ ដើម្បីងាយស្រួល Update ចំនួនក្នុង Map នៅពេលប្រើ Provider
  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // គណនាសរុប (ល្អហើយ!)
  double get total => product.price * quantity;
}