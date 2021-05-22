import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_future_builder.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamedInfo(Routes.editProduct()),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: CustomFutureBuilder(
        future: (ctx) => Provider.of<Products>(ctx, listen: false).fetchAndSet(true),
        successBuilder: (_, __) => Consumer<Products>(
          builder: (_, productsData, __) {
            return RefreshIndicator(
              onRefresh: () => productsData.fetchAndSet(true),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, index) {
                    final product = productsData.items[index];
                    return Column(
                      children: [
                        UserProductItem(id: product.id, title: product.title, imageUrl: product.imageUrl),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
