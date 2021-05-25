import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../actions/actions.dart';
import '../state/state.dart';

final ordersReducer = combineReducers<OrdersSlice>([
  TypedReducer<OrdersSlice, AddOrder>(_addOrder),
  TypedReducer<OrdersSlice, SetOrders>((_, action) => OrdersSlice(action.orders)),
  TypedReducer<OrdersSlice, UpdateAuthCredential>(_logout),
]);

OrdersSlice _addOrder(OrdersSlice state, AddOrder action) =>
    OrdersSlice(state.orders.rebuild((builder) => builder.insert(0, action.order)));

OrdersSlice _logout(OrdersSlice state, UpdateAuthCredential action) =>
    action.credential.isValid ? state : OrdersSlice.initial();
