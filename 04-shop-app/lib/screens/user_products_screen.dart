import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../redux/redux.dart';
import '../routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_future_builder.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen();

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
      drawer: const AppDrawer(),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (_, vm) => CustomFutureBuilder(
          future: (_) => vm.fetchAndSet(),
          successBuilder: (_, __) => RefreshIndicator(
            onRefresh: vm.fetchAndSet,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: vm.products.length,
                itemBuilder: (_, index) {
                  final product = vm.products[index];
                  return Column(
                    children: [
                      UserProductItem(id: product.id, title: product.title, imageUrl: product.imageUrl),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final BuiltList<Product> products;
  final Future<void> Function() fetchAndSet;

  _ViewModel.fromStore(Store<AppState> store)
      : this.products = store.state.productsSlice.userProducts,
        this.fetchAndSet = (() => store.dispatch(FetchAndSetProducts(true)));
}
