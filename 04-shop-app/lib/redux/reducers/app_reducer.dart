import './auth_reducer.dart';
import './cart_reducer.dart';
import './orders_reducer.dart';
import './products_reducer.dart';
import '../state/app_state.dart';

AppState appReducer(AppState state, action) => AppState(
      authSlice: authReducer(state.authSlice, action),
      cartSlice: cartReducer(state.cartSlice, action),
      ordersSlice: ordersReducer(state.ordersSlice, action),
      productsSlice: productsReducer(state.productsSlice, action),
    );
