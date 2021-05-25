import 'package:flutter/material.dart';

import '../redux/redux.dart';
import '../routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamedInfo(Routes.productsOverview),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamedInfo(Routes.orders),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () => Navigator.of(context).pushReplacementNamedInfo(Routes.userProducts),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              StoreProvider.of<AppState>(context, listen: false).dispatch(Logout());
            },
          ),
        ],
      ),
    );
  }
}
