import 'package:flutter/material.dart';

import '../redux/redux.dart';

class ProductDetailScreen extends StatelessWidget {
  final String id;

  const ProductDetailScreen(this.id);

  @override
  Widget build(BuildContext context) {
    final product = StoreProvider.of<AppState>(context, listen: false).state.findProductByID(id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 800),
            ]),
          ),
        ],
      ),
    );
  }
}
