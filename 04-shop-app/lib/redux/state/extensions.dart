import 'package:shop_app/redux/redux.dart';

import './slices.dart';
import '../../models/models.dart';

extension CartSliceExtension on CartSlice {
  int get itemCount => itemsByProduct.length;

  double get totalAmount =>
      itemsByProduct.values.map((item) => item.quantity * item.price).fold(0.0, (previous, next) => previous + next);
}

extension ProductsSliceExtension on ProductsSlice {
  Iterable<Product> get favoriteProducts => allProducts.where((product) => isFavorite(product));

  bool isFavorite(Product product) => favoriteIds.contains(product.id);

  Product findByID(String productID) => allProducts.firstWhere((product) => product.id == productID);
}

extension AppStateExtension on AppState {
  Product findProductByID(String productID) => productsSlice.findByID(productID);

  bool isFavoriteProduct(Product product) => productsSlice.isFavorite(product);
}
