import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../actions/actions.dart';
import '../state/state.dart';

final cartReducer = combineReducers<CartSlice>([
  TypedReducer<CartSlice, AddCartItem>(_addCartItem),
  TypedReducer<CartSlice, RemoveProductFromCart>(_removeProductFromCart),
  TypedReducer<CartSlice, RemoveSingleItemFromCart>(_removeSingleItemFromCart),
  TypedReducer<CartSlice, ClearCart>((_, __) => CartSlice.initial()),
  TypedReducer<CartSlice, UpdateAuthCredential>(_logout),
]);

CartSlice _addCartItem(CartSlice state, AddCartItem action) {
  final product = action.product;
  final builder = state.itemsByProduct.toBuilder();
  var item = builder.remove(product.id);
  if (item == null) {
    item = CartItem(
      title: product.title,
      quantity: 1,
      price: product.price,
    );
  } else {
    item = item.copy(quantity: item.quantity + 1);
  }
  builder.putIfAbsent(product.id, () => item!);
  return CartSlice(builder.build());
}

CartSlice _removeProductFromCart(CartSlice state, RemoveProductFromCart action) =>
    CartSlice(state.itemsByProduct.rebuild((builder) => builder.remove(action.productID)));

CartSlice _removeSingleItemFromCart(CartSlice state, RemoveSingleItemFromCart action) {
  final builder = state.itemsByProduct.toBuilder();
  final item = builder.remove(action.product.id)!;
  if (item.quantity > 1) {
    builder.putIfAbsent(action.product.id, () => item.copy(quantity: item.quantity - 1));
  }
  return CartSlice(builder.build());
}

CartSlice _logout(CartSlice state, UpdateAuthCredential action) =>
    action.credential.isValid ? state : CartSlice.initial();
