class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.variant,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String variant;
  final int quantity;
  final double price;
  final String imageUrl;

  String get formattedPrice => 'PKR ${price.toStringAsFixed(0)}';
}
