// lib/models/card_model.dart
class CardModel {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiry;

  CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
  });
}