import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
class OrdersSlice with JsonRepresentation {
  static final _empty = BuiltList<Order>();

  final BuiltList<Order> orders;

  const OrdersSlice(this.orders);

  OrdersSlice.initial() : this.orders = _empty;

  OrdersSlice.fromJson(json)
      : this.orders = (json['orders'] as List<dynamic>).map((orderData) => Order.fromJson(orderData)).toBuiltList();

  @override
  get jsonMap => {'orders': orders.toList()};
}
