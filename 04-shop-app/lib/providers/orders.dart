import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../firebase.dart';
import 'cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String _authToken;
  final String _userID;

  Orders(this._authToken, this._userID, this._orders);

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final now = DateTime.now();
    final response = await http.post(
      Firebase.orders(_authToken, _userID),
      body: json.encode({
        'amount': total,
        'products': cartProducts
            .map(
              (product) => {
                'id': product.id,
                'title': product.title,
                'quantity': product.quantity,
                'price': product.price,
              },
            )
            .toList(),
        'dateTime': now.toIso8601String(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: now,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSet() async {
    final response = await http.get(Firebase.orders(_authToken, _userID));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    final List<OrderItem> loadedOrders = [];
    extractedData?.forEach((id, orderData) {
      loadedOrders.add(OrderItem(
        id: id,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((productData) => CartItem(
                  id: productData['id'],
                  title: productData['title'],
                  quantity: productData['quantity'],
                  price: productData['price'],
                ))
            .toList(),
      ));
    });
    loadedOrders.sort((o1, o2) => o2.dateTime.compareTo(o1.dateTime));
    _orders = loadedOrders;
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
