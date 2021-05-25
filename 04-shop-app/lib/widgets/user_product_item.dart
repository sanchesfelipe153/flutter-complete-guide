import 'package:flutter/material.dart';

import '../redux/redux.dart';
import '../routes.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  Future<void> _removeProduct(BuildContext context, ScaffoldMessengerState scaffold) async {
    try {
      await StoreProvider.of<AppState>(context, listen: false).dispatch(DeleteProduct(id));
    } catch (error) {
      scaffold.showSnackBar(SnackBar(
        content: Text(
          '$error',
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamedInfo(Routes.editProduct(id)),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeProduct(context, ScaffoldMessenger.of(context)),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
