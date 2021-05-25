import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import './product_item.dart';
import '../models/models.dart';
import '../redux/redux.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(showOnlyFavorites, store),
      builder: (_, vm) => RefreshIndicator(
        onRefresh: vm.fetchAndSet,
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: vm.products.length,
          itemBuilder: (_, index) => ProductItem(vm.products[index]),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final BuiltList<Product> products;
  final Future<void> Function() fetchAndSet;

  _ViewModel.fromStore(bool showOnlyFavorites, Store<AppState> store)
      : this.products = showOnlyFavorites
            ? store.state.productsSlice.favoriteProducts.toBuiltList()
            : store.state.productsSlice.allProducts,
        this.fetchAndSet = (() => store.dispatch(FetchAndSetProducts(false)));
}
