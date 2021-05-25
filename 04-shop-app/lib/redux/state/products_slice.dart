import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
class ProductsSlice with JsonRepresentation {
  static final _empty = BuiltList<Product>();
  static final _emptyIds = BuiltSet<String>();

  final BuiltList<Product> allProducts;
  final BuiltList<Product> userProducts;
  final BuiltSet<String> favoriteIds;

  const ProductsSlice({
    required this.allProducts,
    required this.userProducts,
    required this.favoriteIds,
  });

  ProductsSlice.initial()
      : this.allProducts = _empty,
        this.userProducts = _empty,
        this.favoriteIds = _emptyIds;

  ProductsSlice.fromJson(json)
      : this.allProducts =
            (json['allProducts'] as List<dynamic>).map((product) => Product.fromJson(product)).toBuiltList(),
        this.userProducts =
            (json['userProducts'] as List<dynamic>).map((product) => Product.fromJson(product)).toBuiltList(),
        this.favoriteIds = BuiltSet<String>.from(json['favoriteIds'] as List<dynamic>);

  ProductsSlice copy({
    BuiltList<Product>? allProducts,
    BuiltList<Product>? userProducts,
    BuiltSet<String>? favoriteIds,
  }) =>
      ProductsSlice(
        allProducts: allProducts ?? this.allProducts,
        userProducts: userProducts ?? this.userProducts,
        favoriteIds: favoriteIds ?? this.favoriteIds,
      );

  @override
  get jsonMap => {
        'allProducts': allProducts.toList(),
        'userProducts': userProducts.toList(),
        'favoriteIds': favoriteIds.toList(),
      };
}
