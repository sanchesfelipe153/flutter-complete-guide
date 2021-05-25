import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:redux_thunk/redux_thunk.dart';

import '../../firebase.dart';
import '../../models/models.dart';
import '../state/state.dart';

class UpdateFavorite with JsonRepresentation {
  final Product product;
  final bool favorite;

  const UpdateFavorite._(this.product, this.favorite);

  @override
  get jsonMap => {
        'product': product,
        'favorite': favorite,
      };
}

class InsertProduct with JsonRepresentation {
  final Product product;

  const InsertProduct._(this.product);

  @override
  get jsonMap => {'product': product};
}

class ReplaceProduct with JsonRepresentation {
  final Product product;

  const ReplaceProduct._(this.product);

  @override
  get jsonMap => {'product': product};
}

class RemoveProduct with JsonRepresentation {
  final Product product;

  const RemoveProduct._(this.product);

  @override
  get jsonMap => {'product': product};
}

class SetAllProducts with JsonRepresentation {
  final BuiltList<Product> products;

  const SetAllProducts._(this.products);

  @override
  get jsonMap => {'products': products};
}

class SetUserProducts with JsonRepresentation {
  final BuiltList<Product> products;

  const SetUserProducts._(this.products);

  @override
  get jsonMap => {'products': products};
}

class SetFavorites with JsonRepresentation {
  final BuiltSet<String> favorites;

  SetFavorites._(this.favorites);

  @override
  get jsonMap => {'favorites': favorites};
}

class ToggleFavoriteStatus extends CallableThunkAction<AppState> with JsonRepresentation {
  final Product product;

  ToggleFavoriteStatus(this.product);

  @override
  Future<void> call(store) async {
    final isFavorite = store.state.isFavoriteProduct(product);
    store.dispatch(UpdateFavorite._(product, !isFavorite));

    try {
      final response = await http.put(
        Firebase.userFavorites(store.state.authSlice.credential, productID: product.id),
        body: json.encode(!isFavorite),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Error while updating the product');
      }
    } catch (_) {
      // Rollback
      store.dispatch(UpdateFavorite._(product, isFavorite));
    }
  }

  @override
  get jsonMap => {'product': product};
}

class AddNewProduct extends CallableThunkAction<AppState> with JsonRepresentation {
  final Product product;

  AddNewProduct(this.product);

  @override
  Future<void> call(store) async {
    final credential = store.state.authSlice.credential;

    final response = await http.post(
      Firebase.products(credential),
      body: json.encode(
        product.jsonMap
          ..remove('id')
          ..putIfAbsent('creatorID', () => credential.userID),
      ),
    );

    final newProduct = product.copy(id: json.decode(response.body)['name']!);
    store.dispatch(InsertProduct._(newProduct));
  }

  @override
  get jsonMap => {'product': product};
}

class UpdateProduct extends CallableThunkAction<AppState> with JsonRepresentation {
  final Product product;

  UpdateProduct(this.product);

  @override
  Future<void> call(store) async {
    await http.patch(
      Firebase.products(store.state.authSlice.credential, id: product.id),
      body: json.encode(product.jsonMap..remove('id')),
    );
    store.dispatch(ReplaceProduct._(product));
  }

  @override
  get jsonMap => {'product': product};
}

class DeleteProduct extends CallableThunkAction<AppState> with JsonRepresentation {
  final String productID;

  DeleteProduct(this.productID);

  @override
  Future<void> call(store) async {
    final product = store.state.findProductByID(productID);
    store.dispatch(RemoveProduct._(product));

    try {
      final response = await http.delete(Firebase.products(store.state.authSlice.credential, id: productID));
      if (response.statusCode >= 400) {
        throw const HttpException('Could not delete product');
      }
    } catch (e) {
      store.dispatch(InsertProduct._(product));
      throw e;
    }
  }

  @override
  get jsonMap => {'productID': productID};
}

class FetchAndSetProducts extends CallableThunkAction<AppState> with JsonRepresentation {
  final bool filterByUser;

  FetchAndSetProducts(this.filterByUser);

  @override
  Future<void> call(store) async {
    final credential = store.state.authSlice.credential;

    final response = await http.get(Firebase.products(credential, filterByUser: filterByUser));
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;

    final List<Product> products = [];
    extractedData?.forEach((id, json) => products.add(Product.fromJson(json, id: id)));
    products.sort((p1, p2) {
      final result = p1.title.compareTo(p2.title);
      if (result != 0) return result;
      return p1.id.compareTo(p2.id);
    });

    if (filterByUser) {
      store.dispatch(SetUserProducts._(products.toBuiltList()));
    } else {
      store.dispatch(SetAllProducts._(products.toBuiltList()));
    }

    // Load favorites
    if (!filterByUser) {
      final favoriteResponse = await http.get(Firebase.userFavorites(credential));
      final favoriteMap = json.decode(favoriteResponse.body) as Map<String, dynamic>?;

      final favoriteBuilder = SetBuilder<String>();
      favoriteMap?.forEach((id, favorite) {
        if (favorite) {
          favoriteBuilder.add(id);
        }
      });
      store.dispatch(SetFavorites._(favoriteBuilder.build()));
    }
  }

  @override
  get jsonMap => {'filterByUser': filterByUser};
}
