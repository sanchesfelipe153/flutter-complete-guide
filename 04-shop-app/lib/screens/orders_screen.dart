import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/custom_future_builder.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: CustomFutureBuilder(
        future: (ctx) => Provider.of<Orders>(ctx, listen: false).fetchAndSet(),
        successBuilder: (_, __) => Consumer<Orders>(builder: (_, orderData, __) {
          final orders = orderData.orders;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) => OrderItem(orders[index]),
          );
        }),
      ),
    );
  }
}
