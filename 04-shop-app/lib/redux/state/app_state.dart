import 'package:meta/meta.dart';

import './slices.dart';
import '../../models/models.dart';

@immutable
class AppState with JsonRepresentation {
  final AuthSlice authSlice;
  final CartSlice cartSlice;
  final OrdersSlice ordersSlice;
  final ProductsSlice productsSlice;

  AppState({
    required this.authSlice,
    required this.cartSlice,
    required this.ordersSlice,
    required this.productsSlice,
  });

  AppState.fromJson(json)
      : this.authSlice = AuthSlice.fromJson(json['authSlice']),
        this.cartSlice = CartSlice.fromJson(json['cartSlice']),
        this.ordersSlice = OrdersSlice.fromJson(json['ordersSlice']),
        this.productsSlice = ProductsSlice.fromJson(json['productsSlice']);

  AppState.initial()
      : this.authSlice = AuthSlice.initial(),
        this.cartSlice = CartSlice.initial(),
        this.ordersSlice = OrdersSlice.initial(),
        this.productsSlice = ProductsSlice.initial();

  AppState copy({
    AuthSlice? authSlice,
    CartSlice? cartSlice,
    OrdersSlice? ordersSlice,
    ProductsSlice? productsSlice,
  }) =>
      AppState(
        authSlice: authSlice ?? this.authSlice,
        cartSlice: cartSlice ?? this.cartSlice,
        ordersSlice: ordersSlice ?? this.ordersSlice,
        productsSlice: productsSlice ?? this.productsSlice,
      );

  @override
  get jsonMap => {
        'authSlice': authSlice,
        'cartSlice': cartSlice,
        'ordersSlice': ordersSlice,
        'productsSlice': productsSlice,
      };
}
