import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final String id;

  const ProductDetailScreen(this.id);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false).findByID(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
