import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../redux/redux.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_future_builder.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (_, vm) => CustomFutureBuilder(
          future: (_) => vm.fetchAndSet(),
          successBuilder: (_, __) => RefreshIndicator(
            onRefresh: vm.fetchAndSet,
            child: ListView.builder(
              itemCount: vm.orders.length,
              itemBuilder: (_, index) => OrderItem(vm.orders[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final BuiltList<Order> orders;
  final Future<void> Function() fetchAndSet;

  _ViewModel.fromStore(Store<AppState> store)
      : this.orders = store.state.ordersSlice.orders,
        this.fetchAndSet = (() => store.dispatch(FetchAndSetOrders()));
}
