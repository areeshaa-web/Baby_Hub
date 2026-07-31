import 'package:flutter/material.dart';

import '../models/address_model.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/coupon_model.dart';
import '../models/delivery_method_model.dart';
import '../models/payment_method_model.dart';
import '../models/product_model.dart';

class CartController extends ChangeNotifier {
  CartController() {
    _loadInitialCart();
  }

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  CartModel _cart = const CartModel(items: [], appliedCoupon: null);
  AddressModel? selectedAddress;
  DeliveryMethodModel? selectedDeliveryMethod;
  PaymentMethodModel? selectedPaymentMethod;
  String couponCode = '';
  String couponMessage = '';
  bool couponApplied = false;
  bool isPlacingOrder = false;
  String? lastPlacedOrderNumber;

  CartModel get cart => _cart;
  List<CartItemModel> get activeItems => _cart.items.where((item) => !item.isSavedForLater).toList();
  List<CartItemModel> get savedItems => _cart.items.where((item) => item.isSavedForLater).toList();
  double get subtotal => activeItems.fold(0.0, (sum, item) => sum + item.lineTotal);
  double get discount => couponApplied && _cart.appliedCoupon != null ? subtotal * (_cart.appliedCoupon!.discountPercent / 100) : 0;
  double get tax => subtotal * 0.08;
  double get deliveryCharges => selectedDeliveryMethod?.fee ?? 0;
  double get grandTotal => subtotal - discount + tax + deliveryCharges;
  double get totalItems => activeItems.fold(0.0, (sum, item) => sum + item.quantity);

  Future<void> _loadInitialCart() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _cart = CartModel(
      items: [
        CartItemModel(
          id: 'ci1',
          product: const ProductModel(
            id: 'p1',
            name: 'Cotton Romper Set',
            variant: 'Size 6M',
            quantity: 12,
            price: 1650,
            imageUrl: 'https://alayajunior.com/cdn/shop/files/Carters-Pack-Of-3-Baby-Rompers-Bear-And-Stars-Beige.webp?v=1768772145&width=1445',
          ),
          quantity: 1,
        ),
        CartItemModel(
          id: 'ci2',
          product: const ProductModel(
            id: 'p2',
            name: 'Soft Teddy Bear',
            variant: 'Cream',
            quantity: 8,
            price: 1250,
            imageUrl: 'https://toyshutch.pk/cdn/shop/files/soft-stuffed-teddy-bear-with-cap-101905.webp?v=1778759066',
          ),
          quantity: 2,
        ),
      ],
      appliedCoupon: null,
    );

    selectedAddress = const AddressModel(
      name: 'Ayesha Khan',
      line1: 'House 12, Gulberg 3',
      city: 'Lahore',
      state: 'Punjab',
      zipCode: '54000',
      country: 'Pakistan',
      phone: '+92 300 1234567',
    );
    selectedDeliveryMethod = const DeliveryMethodModel(
      id: 'standard',
      title: 'Standard Delivery',
      subtitle: '2-4 business days',
      fee: 200,
    );
    selectedPaymentMethod = const PaymentMethodModel(id: 'cod', title: 'Cash on Delivery', subtitle: 'Pay on delivery');

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshCart() async {
    hasError = false;
    errorMessage = '';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    notifyListeners();
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = activeItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      final updated = activeItems[existingIndex].copyWith(quantity: activeItems[existingIndex].quantity + quantity);
      _cart = CartModel(
        items: [
          for (final item in activeItems)
            if (item.product.id == product.id) updated else item,
          ...savedItems,
        ],
        appliedCoupon: _cart.appliedCoupon,
      );
    } else {
      _cart = CartModel(
        items: [
          ...activeItems,
          CartItemModel(id: 'ci-${DateTime.now().millisecondsSinceEpoch}', product: product, quantity: quantity),
          ...savedItems,
        ],
        appliedCoupon: _cart.appliedCoupon,
      );
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final updatedItems = activeItems.map((item) {
      if (item.id != itemId) return item;
      final newQuantity = (item.quantity + delta).clamp(1, 10);
      return item.copyWith(quantity: newQuantity);
    }).toList();

    _cart = CartModel(items: [...updatedItems, ...savedItems], appliedCoupon: _cart.appliedCoupon);
    notifyListeners();
  }

  void removeItem(String itemId) {
    _cart = CartModel(items: activeItems.where((item) => item.id != itemId).toList() + savedItems, appliedCoupon: _cart.appliedCoupon);
    notifyListeners();
  }

  void saveForLater(String itemId) {
    final item = activeItems.firstWhere((entry) => entry.id == itemId);
    _cart = CartModel(
      items: [
        ...activeItems.where((entry) => entry.id != itemId),
        item.copyWith(isSavedForLater: true),
        ...savedItems,
      ],
      appliedCoupon: _cart.appliedCoupon,
    );
    notifyListeners();
  }

  void moveBackToCart(String itemId) {
    final item = savedItems.firstWhere((entry) => entry.id == itemId);
    _cart = CartModel(
      items: [
        ...activeItems,
        item.copyWith(isSavedForLater: false),
        ...savedItems.where((entry) => entry.id != itemId),
      ],
      appliedCoupon: _cart.appliedCoupon,
    );
    notifyListeners();
  }

  Future<void> applyCoupon(String code) async {
    couponCode = code;
    couponMessage = '';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (code.toLowerCase() == 'baby10') {
      _cart = CartModel(items: _cart.items, appliedCoupon: const CouponModel(code: 'BABY10', description: '10% off baby essentials', discountPercent: 10));
      couponApplied = true;
      couponMessage = 'Coupon applied successfully';
    } else {
      couponApplied = false;
      couponMessage = 'Coupon is invalid';
    }
    notifyListeners();
  }

  void removeCoupon() {
    _cart = CartModel(items: _cart.items, appliedCoupon: null);
    couponApplied = false;
    couponMessage = 'Coupon removed';
    notifyListeners();
  }

  void selectAddress(AddressModel address) {
    selectedAddress = address;
    notifyListeners();
  }

  void selectDeliveryMethod(DeliveryMethodModel method) {
    selectedDeliveryMethod = method;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    if (selectedAddress == null || selectedPaymentMethod == null || activeItems.isEmpty || !couponApplied && _cart.appliedCoupon != null) {
      hasError = true;
      errorMessage = 'Please complete the checkout details';
      notifyListeners();
      return false;
    }

    isPlacingOrder = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    isPlacingOrder = false;
    lastPlacedOrderNumber = 'BH78455';
    _cart = const CartModel(items: [], appliedCoupon: null);
    couponApplied = false;
    couponCode = '';
    couponMessage = 'Order placed successfully';
    hasError = false;
    errorMessage = '';
    notifyListeners();
    return true;
  }
}
