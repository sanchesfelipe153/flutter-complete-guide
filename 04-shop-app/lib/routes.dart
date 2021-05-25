import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';

class Routes {
  Routes._();

  static final auth = NamedRouteInfo._('/auth', (_) => const AuthScreen());
  static final cart = NamedRouteInfo._('/cart', (_) => const CartScreen());
  static final orders = NamedRouteInfo._('/orders', (_) => const OrdersScreen());
  static final productsOverview = NamedRouteInfo._('/products-overview', (_) => const ProductsOverviewScreen());
  static final userProducts = NamedRouteInfo._('/user-products', (_) => const UserProductsScreen());

  static NamedRouteInfo productDetail(String id) {
    return NamedRouteInfo._('/product-detail', (_) => ProductDetailScreen(id));
  }

  static NamedRouteInfo editProduct([String? id]) {
    return NamedRouteInfo._('/edit-product', (_) => EditProductScreen(id));
  }

  static final RouteFactory generator = (settings) {
    if (settings.arguments is NamedRouteInfo) {
      return _CustomRoute(builder: (settings.arguments as NamedRouteInfo)._builder);
    }
    return null;
  };
}

extension RoutesExtension on NavigatorState {
  Future<T?> pushNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushNamed(route.name, arguments: route);
  }

  Future<T?> pushReplacementNamedInfo<T extends Object?>(NamedRouteInfo route) {
    return this.pushReplacementNamed(route.name, arguments: route);
  }
}

class NamedRouteInfo {
  final String name;
  final WidgetBuilder _builder;

  const NamedRouteInfo._(this.name, this._builder);

  Widget build(BuildContext context) => _builder(context);

  @override
  String toString() => name;
}

class _CustomRoute<T> extends MaterialPageRoute<T> {
  _CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }
}
