import 'package:flutter/material.dart';

import '../redux/redux.dart';
import '../routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/custom_future_builder.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen();

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _filterOption = _FilterOption.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (_FilterOption selectedValue) => setState(() => _filterOption = selectedValue),
            itemBuilder: (_) => const [
              PopupMenuItem(child: Text('Only Favorites'), value: _FilterOption.Favorites),
              PopupMenuItem(child: Text('Show All'), value: _FilterOption.All),
            ],
          ),
          StoreConnector<AppState, int>(
            distinct: true,
            converter: (store) => store.state.cartSlice.itemCount,
            builder: (ctx, itemCount) => Badge(
              value: itemCount.toString(),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.of(ctx).pushNamedInfo(Routes.cart),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: CustomFutureBuilder(
        future: (ctx) => StoreProvider.of<AppState>(ctx, listen: false).dispatch(FetchAndSetProducts(false)),
        successBuilder: (_, __) => ProductsGrid(_filterOption == _FilterOption.Favorites),
      ),
    );
  }
}

enum _FilterOption { Favorites, All }
