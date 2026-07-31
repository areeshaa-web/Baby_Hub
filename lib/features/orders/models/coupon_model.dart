class CouponModel {
  const CouponModel({
    required this.code,
    required this.description,
    required this.discountPercent,
  });

  final String code;
  final String description;
  final double discountPercent;
}
