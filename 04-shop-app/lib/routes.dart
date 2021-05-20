import 'package:flutter/material.dart';

import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products_screen.dart';

class Routes {
  Routes._();

  static const home = NamedRouteInfo(_home);
  static const cart = NamedRouteInfo(_cart);
  static const orders = NamedRouteInfo(_orders);
  static const userProducts = NamedRouteInfo(_userProducts);

  static NamedRouteInfo productDetail(String id) {
    return NamedRouteInfo(_productDetail, data: id);
  }

  static NamedRouteInfo editProduct([String? id]) {
    return NamedRouteInfo(_editProduct, data: id);
  }

  static const _home = '/';
  static const _cart = '/cart';
  static const _orders = '/orders';
  static const _productDetail = '/product-detail';
  static const _userProducts = '/user-products';
  static const _editProduct = '/edit-product';

  static final RouteFactory generator = (settings) {
    final WidgetBuilder builder;
    switch (settings.name) {
      case _home:
        builder = (_) => ProductsOverviewScreen();
        break;
      case _cart:
        builder = (_) => CartScreen();
        break;
      case _orders:
        builder = (_) => OrdersScreen();
        break;
      case _userProducts:
        builder = (_) => UserProductsScreen();
        break;
      case _productDetail:
        builder = (_) {
          final id = settings.arguments as String;
          return ProductDetailScreen(id);
        };
        break;
      case _editProduct:
        builder = (_) {
          final id = settings.arguments as String?;
          return EditProductScreen(id);
        };
        break;
      default:
        throw Exception('Must implement ${settings.name} route');
    }

    return MaterialPageRoute(builder: builder);
  };
}

extension RoutesExtension on NavigatorState {
  Future<T?> pushNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushNamed(route.name, arguments: route.data);
  }

  Future<T?> pushReplacementNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushReplacementNamed(route.name, arguments: route.data);
  }
}

class NamedRouteInfo {
  final String name;
  final Object? data;

  const NamedRouteInfo(this.name, {this.data});
}
