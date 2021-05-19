import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Cart with ChangeNotifier {
  final _uuid = Uuid();

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount =>
      _items.values.map((item) => item.quantity * item.price).fold(0.0, (previous, next) => previous + next);

  void addItem(String productID, double price, String title) {
    if (_items.containsKey(productID)) {
      _items.update(
        productID,
        (oldItem) => CartItem(
          id: oldItem.id,
          title: oldItem.title,
          quantity: oldItem.quantity + 1,
          price: oldItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: _uuid.v4(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}
