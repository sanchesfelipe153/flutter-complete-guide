import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import './json_representation.dart';

@immutable
class CartItem with JsonRepresentation {
  static const _uuid = Uuid();

  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    String? id,
    required this.title,
    required this.quantity,
    required this.price,
  }) : this.id = id ?? _uuid.v4();

  CartItem.fromJson(json)
      : this.id = json['id'] ?? '',
        this.title = json['title'],
        this.quantity = json['quantity'],
        this.price = json['price'];

  CartItem copy({
    String? id,
    String? title,
    int? quantity,
    double? price,
  }) =>
      CartItem(
        id: id ?? this.id,
        title: title ?? this.title,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
      );

  @override
  get jsonMap => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
      };
}
