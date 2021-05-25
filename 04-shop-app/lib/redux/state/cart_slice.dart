import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
class CartSlice with JsonRepresentation {
  static final _empty = BuiltMap<String, CartItem>();

  final BuiltMap<String, CartItem> itemsByProduct;

  const CartSlice(this.itemsByProduct);

  CartSlice.initial() : this.itemsByProduct = _empty;

  CartSlice.fromJson(json)
      : this.itemsByProduct = (json['itemsByProduct'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, CartItem.fromJson(value)))
            .build();

  @override
  get jsonMap => {'itemsByProduct': itemsByProduct.toMap()};
}
