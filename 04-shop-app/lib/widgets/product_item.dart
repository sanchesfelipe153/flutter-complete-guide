import 'package:flutter/material.dart';

import '../models/models.dart';
import '../redux/redux.dart';
import '../routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamedInfo(Routes.productDetail(product.id)),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: StoreConnector<AppState, _ViewModel>(
            distinct: true,
            converter: (store) => _ViewModel.fromStore(product, store),
            builder: (_, vm) => IconButton(
              icon: Icon(vm.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: vm.toggleFavorite,
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context, listen: false);
              store.dispatch(AddCartItem(product));

              final scaffold = ScaffoldMessenger.of(context);
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => store.dispatch(RemoveSingleItemFromCart(product)),
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool isFavorite;
  final Function() toggleFavorite;

  _ViewModel.fromStore(Product product, Store<AppState> store)
      : this.isFavorite = store.state.isFavoriteProduct(product),
        this.toggleFavorite = (() => store.dispatch(ToggleFavoriteStatus(product)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel && runtimeType == other.runtimeType && isFavorite == other.isFavorite;

  @override
  int get hashCode => isFavorite.hashCode;
}
