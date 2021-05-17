import 'package:flutter/material.dart';

import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';

class Routes {
  Routes._();

  static const home = NamedRouteInfo(_home);

  static NamedRouteInfo productDetail(String id) {
    return NamedRouteInfo(_productDetail, data: id);
  }

  static const _home = '/';
  static const _productDetail = '/product-detail';

  static final RouteFactory generator = (settings) {
    final WidgetBuilder builder;
    switch (settings.name) {
      case _home:
        builder = (_) => ProductsOverviewScreen();
        break;
      case _productDetail:
        builder = (_) {
          final id = settings.arguments as String;
          return ProductDetailScreen(id);
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
