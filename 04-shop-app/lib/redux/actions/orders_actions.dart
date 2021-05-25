import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:redux_thunk/redux_thunk.dart';

import '../../firebase.dart';
import '../../models/models.dart';
import '../state/state.dart';

class AddOrder with JsonRepresentation {
  final Order order;

  const AddOrder._(this.order);

  @override
  get jsonMap => {'order': order};
}

class SetOrders with JsonRepresentation {
  final BuiltList<Order> orders;

  SetOrders._(this.orders);

  @override
  get jsonMap => {'orders': orders};
}

class CreateOrder extends CallableThunkAction<AppState> {
  @override
  Future<void> call(store) async {
    final now = DateTime.now();

    final cart = store.state.cartSlice;
    final total = cart.totalAmount;
    final cartItems = cart.itemsByProduct.values;
    final response = await http.post(
      Firebase.orders(store.state.authSlice.credential),
      body: json.encode({
        'amount': total,
        'products': cartItems.map((item) => item.toJson()).toList(),
        'dateTime': now.toIso8601String(),
      }),
    );
    store.dispatch(AddOrder._(
      Order(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartItems.toBuiltList(),
        dateTime: now,
      ),
    ));
  }
}

class FetchAndSetOrders extends CallableThunkAction<AppState> {
  @override
  Future<void> call(store) async {
    final response = await http.get(Firebase.orders(store.state.authSlice.credential));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    final List<Order> loadedOrders = [];
    extractedData?.forEach(
      (id, orderJson) => loadedOrders.add(
        Order.fromJson(orderJson).copy(id: id),
      ),
    );
    loadedOrders.sort((o1, o2) => o2.dateTime.compareTo(o1.dateTime));
    store.dispatch(SetOrders._(loadedOrders.toBuiltList()));
  }
}
