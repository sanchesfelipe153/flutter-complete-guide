import 'package:flutter/material.dart';

import '../redux/redux.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.productID,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to remove the item from the cart?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      ),
      onDismissed: (_) => StoreProvider.of<AppState>(context, listen: false).dispatch(RemoveProductFromCart(productID)),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('\$${price.toStringAsFixed(2)}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(quantity * price).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
