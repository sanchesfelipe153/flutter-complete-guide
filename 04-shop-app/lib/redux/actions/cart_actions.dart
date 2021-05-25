import '../../models/models.dart';

class AddCartItem with JsonRepresentation {
  final Product product;

  const AddCartItem(this.product);

  @override
  get jsonMap => {'product': product};
}

class RemoveProductFromCart with JsonRepresentation {
  final String productID;

  const RemoveProductFromCart(this.productID);

  @override
  get jsonMap => {'productID': productID};
}

class RemoveSingleItemFromCart with JsonRepresentation {
  final Product product;

  const RemoveSingleItemFromCart(this.product);

  @override
  get jsonMap => {'product': product};
}

class ClearCart {}
