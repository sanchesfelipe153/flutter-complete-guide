import 'package:meta/meta.dart';

import './json_representation.dart';

@immutable
class Product with JsonRepresentation {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  Product.fromJson(json, {String? id})
      : this.id = id ?? json['id'] ?? '',
        this.title = json['title'],
        this.description = json['description'],
        this.price = json['price'],
        this.imageUrl = json['imageUrl'];

  Product copy({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  get jsonMap => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };
}
