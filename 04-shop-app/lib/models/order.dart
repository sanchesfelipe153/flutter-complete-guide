import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import './cart_item.dart';
import './json_representation.dart';

@immutable
class Order with JsonRepresentation {
  final String id;
  final double amount;
  final BuiltList<CartItem> products;
  final DateTime dateTime;

  const Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Order.fromJson(json)
      : this.id = json['id'] ?? '',
        this.amount = json['amount'],
        this.products =
            (json['products'] as List<dynamic>).map((productData) => CartItem.fromJson(productData)).toBuiltList(),
        this.dateTime = DateTime.parse(json['dateTime']);

  Order copy({
    String? id,
    double? amount,
    Iterable<CartItem>? products,
    DateTime? dateTime,
  }) =>
      Order(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        products: BuiltList.of(products ?? this.products),
        dateTime: dateTime ?? this.dateTime,
      );

  @override
  get jsonMap => {
        'id': id,
        'amount': amount,
        'products': products,
        'dateTime': dateTime.toIso8601String(),
      };
}
