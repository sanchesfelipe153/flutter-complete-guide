import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../firebase.dart';
import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String _authToken;
  final String _userID;

  Products(this._authToken, this._userID, this._items);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((item) => item.isFavorite).toList();

  Product findByID(String id) => _items.firstWhere((item) => item.id == id);

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Firebase.products(_authToken),
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorID': _userID,
      }),
    );

    final newProduct = product.copy(id: json.decode(response.body)['name']!);
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    await http.patch(
      Firebase.products(_authToken, id: product.id),
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
    final response = await http.delete(Firebase.products(_authToken, id: id));
    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
  }

  Future<void> fetchAndSet([bool filterByUser = false]) async {
    final response = await http.get(Firebase.products(_authToken, userID: filterByUser ? _userID : null));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    final List<Product> loadedProducts = [];
    _items = loadedProducts;
    if (extractedData == null) {
      notifyListeners();
      return;
    }

    final favoriteResponse = await http.get(Firebase.userFavorites(_authToken, _userID));
    final favoriteMap = json.decode(favoriteResponse.body) as Map<String, dynamic>? ?? {};

    extractedData.forEach((id, map) {
      loadedProducts.add(Product(
        id: id,
        title: map['title'],
        description: map['description'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        isFavorite: favoriteMap[id] ?? false,
      ));
    });
    notifyListeners();
  }
}
