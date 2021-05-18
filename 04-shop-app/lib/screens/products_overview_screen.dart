import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
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
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: _FilterOption.Favorites),
              PopupMenuItem(child: Text('Show All'), value: _FilterOption.All),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_filterOption == _FilterOption.Favorites),
    );
  }
}

enum _FilterOption { Favorites, All }
