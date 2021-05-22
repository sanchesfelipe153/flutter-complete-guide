import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../firebase.dart';
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product copy({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  Future<void> toggleFavoriteStatus(String authToken, String userID) async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        Firebase.userFavorites(authToken, userID, id),
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Error while updating the product');
      }
    } catch (_) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
