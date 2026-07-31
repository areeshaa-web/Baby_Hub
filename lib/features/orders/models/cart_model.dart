import 'cart_item_model.dart';
import 'coupon_model.dart';

class CartModel {
  const CartModel({
    required this.items,
    required this.appliedCoupon,
  });

  final List<CartItemModel> items;
  final CouponModel? appliedCoupon;
}
