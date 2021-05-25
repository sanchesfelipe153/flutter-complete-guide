import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../actions/actions.dart';
import '../state/state.dart';

final productsReducer = combineReducers<ProductsSlice>([
  TypedReducer<ProductsSlice, UpdateFavorite>(_updateFavorite),
  TypedReducer<ProductsSlice, InsertProduct>(_insertProduct),
  TypedReducer<ProductsSlice, ReplaceProduct>(_replaceProduct),
  TypedReducer<ProductsSlice, RemoveProduct>(_removeProduct),
  TypedReducer<ProductsSlice, SetAllProducts>(_setAllProducts),
  TypedReducer<ProductsSlice, SetUserProducts>(_setUserProducts),
  TypedReducer<ProductsSlice, SetFavorites>(_setFavorites),
  TypedReducer<ProductsSlice, UpdateAuthCredential>(_logout),
]);

ProductsSlice _updateFavorite(ProductsSlice state, UpdateFavorite action) {
  final builder = state.favoriteIds.toBuilder();
  if (action.favorite) {
    builder.add(action.product.id);
  } else {
    builder.remove(action.product.id);
  }
  return state.copy(favoriteIds: builder.build());
}

ProductsSlice _insertProduct(ProductsSlice state, InsertProduct action) {
  final allProducts = state.allProducts.rebuild((builder) => builder.insert(0, action.product));
  final userProducts = state.userProducts.rebuild((builder) => builder.insert(0, action.product));
  return state.copy(
    allProducts: allProducts,
    userProducts: userProducts,
  );
}

ProductsSlice _replaceProduct(ProductsSlice state, ReplaceProduct action) {
  final allProducts = state.allProducts.rebuild((builder) {
    final index = state.allProducts.indexWhere((product) => product.id == action.product.id);
    builder.removeAt(index);
    builder.insert(index, action.product);
  });
  final userProducts = state.userProducts.rebuild((builder) {
    final index = state.userProducts.indexWhere((product) => product.id == action.product.id);
    builder.removeAt(index);
    builder.insert(index, action.product);
  });
  return state.copy(
    allProducts: allProducts,
    userProducts: userProducts,
  );
}

ProductsSlice _removeProduct(ProductsSlice state, RemoveProduct action) {
  final allProducts =
      state.allProducts.rebuild((builder) => builder.removeWhere((product) => product.id == action.product.id));
  final userProducts =
      state.userProducts.rebuild((builder) => builder.removeWhere((product) => product.id == action.product.id));
  return state.copy(
    allProducts: allProducts,
    userProducts: userProducts,
  );
}

ProductsSlice _setAllProducts(ProductsSlice state, SetAllProducts action) => state.copy(allProducts: action.products);

ProductsSlice _setUserProducts(ProductsSlice state, SetUserProducts action) =>
    state.copy(userProducts: action.products);

ProductsSlice _setFavorites(ProductsSlice state, SetFavorites action) => state.copy(favoriteIds: action.favorites);

ProductsSlice _logout(ProductsSlice state, UpdateAuthCredential action) =>
    action.credential.isValid ? state : ProductsSlice.initial();
