import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = Provider.of<Orders>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.error != null) {
                return const Center(child: Text('An error occurred'));
              }
              return Consumer<Orders>(builder: (_, orderData, __) {
                final orders = orderData.orders;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (_, index) => OrderItem(orders[index]),
                );
              });
          }
        },
      ),
    );
  }
}
