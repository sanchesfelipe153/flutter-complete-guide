import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import '../models/models.dart' as models;
import '../redux/redux.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (_, vm) {
          final products = vm.itemsByProduct.keys.toBuiltList();
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(
                          '\$${vm.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6?.color),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      const _OrderButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];
                    final item = vm.itemsByProduct[product]!;
                    return CartItem(
                      id: item.id,
                      productID: product,
                      title: item.title,
                      quantity: item.quantity,
                      price: item.price,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderButton extends StatefulWidget {
  const _OrderButton();

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<_OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (_, vm) => TextButton(
        child: _isLoading ? const CircularProgressIndicator() : const Text('ORDER NOW'),
        onPressed: vm.itemsByProduct.isEmpty || _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                await vm.createOrder();
                vm.clearCart();
                setState(() => _isLoading = false);
              },
      ),
    );
  }
}

class _ViewModel {
  final double totalAmount;
  final BuiltMap<String, models.CartItem> itemsByProduct;
  final Function() clearCart;
  final Future<void> Function() createOrder;

  _ViewModel.fromStore(Store<AppState> store)
      : this.totalAmount = store.state.cartSlice.totalAmount,
        this.itemsByProduct = store.state.cartSlice.itemsByProduct,
        this.clearCart = (() => store.dispatch(ClearCart())),
        this.createOrder = (() => store.dispatch(CreateOrder()));
}
