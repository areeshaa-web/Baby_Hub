import 'product_model.dart';

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.isSavedForLater = false,
    this.stockAvailable = true,
  });

  final String id;
  final ProductModel product;
  final int quantity;
  final bool isSavedForLater;
  final bool stockAvailable;

  double get lineTotal => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    bool? isSavedForLater,
    bool? stockAvailable,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSavedForLater: isSavedForLater ?? this.isSavedForLater,
      stockAvailable: stockAvailable ?? this.stockAvailable,
    );
  }
}
