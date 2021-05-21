import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../firebase.dart';
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((item) => item.isFavorite).toList();

  Product findByID(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Firebase.products(),
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );

    final newProduct = product.copy(id: json.decode(response.body)['name']!);
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    await http.patch(
      Firebase.products(product.id),
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      }),
    );
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    final product = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(Firebase.products(id));
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
  }

  Future<void> fetchAndSet() async {
    final response = await http.get(Firebase.products());
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    final List<Product> loadedProducts = [];
    extractedData?.forEach((id, map) {
      loadedProducts.add(Product(
        id: id,
        title: map['title'],
        description: map['description'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        isFavorite: map['isFavorite'] ?? false,
      ));
    });
    _items = loadedProducts;
    notifyListeners();
  }
}
