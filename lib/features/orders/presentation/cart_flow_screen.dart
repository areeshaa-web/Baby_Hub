import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../models/address_model.dart';
import '../models/cart_item_model.dart';
import '../models/delivery_method_model.dart';
import '../models/payment_method_model.dart';
import 'orders_screen.dart';

class CartFlowScreen extends StatelessWidget {
  const CartFlowScreen({super.key, this.onContinueShopping});

  final VoidCallback? onContinueShopping;

  @override
  Widget build(BuildContext context) {
    return _CartFlowScreen(onContinueShopping: onContinueShopping);
  }
}

class _CartFlowScreen extends StatefulWidget {
  const _CartFlowScreen({this.onContinueShopping});

  final VoidCallback? onContinueShopping;

  @override
  State<_CartFlowScreen> createState() => _CartFlowScreenState();
}

class _CartFlowScreenState extends State<_CartFlowScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();

    if (controller.isLoading) {
      return const LoadingWidget(message: 'Loading your cart');
    }

    if (controller.hasError) {
      return _buildNetworkError(controller);
    }

    if (controller.activeItems.isEmpty && controller.savedItems.isEmpty) {
      return EmptyCartWidget(onContinueShopping: widget.onContinueShopping);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Cart', style: TextStyle(color: Color(0xFF2F2148), fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2F2148)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartSummaryPage())),
                icon: const Icon(Icons.receipt_long_outlined),
              ),
              if (controller.activeItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFFF5C8A), shape: BoxShape.circle),
                    child: Text('${controller.activeItems.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshCart,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            ...controller.activeItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CartItemCard(item: item),
                )),
            if (controller.savedItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Saved for Later', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
              const SizedBox(height: 8),
              ...controller.savedItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SavedItemCard(item: item),
                  )),
            ],
            const SizedBox(height: 12),
            CouponWidget(),
            const SizedBox(height: 12),
            PriceSummaryCard(),
            const SizedBox(height: 16),
            CheckoutButton(
              label: 'Proceed to Checkout',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFFFFE7E9), Color(0xFFEDE4FF)]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Yay! You\'re just one step away from adorable happiness!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                SizedBox(height: 8),
                Text('Free shipping on orders above PKR 3,000 and baby-safe essentials delivered fast.', style: TextStyle(fontSize: 12, color: Color(0xFF6C6482))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.baby_changing_station_outlined, size: 56, color: Color(0xFFFF5C8A)),
        ],
      ),
    );
  }

  Widget _buildNetworkError(CartController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 70, color: Color(0xFFFF5C8A)),
            const SizedBox(height: 14),
            Text(controller.errorMessage.isEmpty ? 'We hit a snag' : controller.errorMessage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Please check your connection and try again.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.refreshCart(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C8A), foregroundColor: Colors.white),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartSummaryPage extends StatelessWidget {
  const CartSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your Cart', style: TextStyle(color: Color(0xFF2F2148), fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2F2148)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...controller.activeItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(item.product.imageUrl, width: 64, height: 64, fit: BoxFit.cover)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                                    const SizedBox(height: 4),
                                    Text(item.product.variant, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 6),
                                    Text('PKR ${item.lineTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFF5C8A))),
                                  ],
                                ),
                              ),
                              QuantitySelector(itemId: item.id, quantity: item.quantity),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 12),
                  PriceSummaryCard(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: Color(0xFFFF5C8A))),
                    child: const Text('Continue Shopping', style: TextStyle(color: Color(0xFFFF5C8A))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CheckoutButton(
                    label: 'Checkout',
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CheckoutPage())),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final List<AddressModel> _addresses = [
    const AddressModel(name: 'Ayesha Khan', line1: 'House 12, Gulberg 3', city: 'Lahore', state: 'Punjab', zipCode: '54000', country: 'Pakistan', phone: '+92 300 1234567'),
    const AddressModel(name: 'Sara Malik', line1: 'Flat 8, DHA', city: 'Islamabad', state: 'Islamabad', zipCode: '44000', country: 'Pakistan', phone: '+92 320 9876543'),
  ];

  final List<DeliveryMethodModel> _deliveryMethods = const [
    DeliveryMethodModel(id: 'standard', title: 'Standard Delivery', subtitle: '2-4 business days', fee: 200),
    DeliveryMethodModel(id: 'express', title: 'Express Delivery', subtitle: 'Same day dispatch', fee: 400),
    DeliveryMethodModel(id: 'same-day', title: 'Same Day Delivery', subtitle: 'Within 2 hours', fee: 650),
  ];

  final List<PaymentMethodModel> _paymentMethods = const [
    PaymentMethodModel(id: 'cod', title: 'Cash on Delivery', subtitle: 'Pay when delivered'),
    PaymentMethodModel(id: 'card', title: 'Credit Card', subtitle: 'Visa / MasterCard'),
    PaymentMethodModel(id: 'debit', title: 'Debit Card', subtitle: 'Use your debit card'),
    PaymentMethodModel(id: 'easypaisa', title: 'EasyPaisa', subtitle: 'Fast wallet transfer'),
    PaymentMethodModel(id: 'jazzcash', title: 'JazzCash', subtitle: 'Mobile wallet'),
    PaymentMethodModel(id: 'bank', title: 'Bank Transfer', subtitle: 'Direct transfer'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Color(0xFF2F2148), fontWeight: FontWeight.w700)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2F2148)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          const SizedBox(height: 8),
          ..._addresses.map((address) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AddressCard(
                  address: address,
                  selected: controller.selectedAddress?.line1 == address.line1,
                  onSelect: () => controller.selectAddress(address),
                  onDelete: () => setState(() => _addresses.remove(address)),
                ),
              )),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final newAddress = await _showAddressDialog(context);
              if (newAddress != null) {
                setState(() => _addresses.add(newAddress));
                controller.selectAddress(newAddress);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
          ),
          const SizedBox(height: 20),
          const Text('Delivery Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          const SizedBox(height: 8),
          ..._deliveryMethods.map((method) => DeliveryOptionCard(
                method: method,
                selected: controller.selectedDeliveryMethod?.id == method.id,
                onTap: () => controller.selectDeliveryMethod(method),
              )),
          const SizedBox(height: 20),
          const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          const SizedBox(height: 8),
          ..._paymentMethods.map((method) => PaymentCard(
                method: method,
                selected: controller.selectedPaymentMethod?.id == method.id,
                onTap: () => controller.selectPaymentMethod(method),
              )),
          const SizedBox(height: 20),
          PriceSummaryCard(isCheckout: true),
          const SizedBox(height: 16),
          CheckoutButton(
            label: controller.isPlacingOrder ? 'Placing Order...' : 'Place Order',
            isLoading: controller.isPlacingOrder,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final success = await controller.placeOrder();
              if (success && mounted) {
                navigator.pushReplacement(MaterialPageRoute(builder: (_) => const OrderSuccessPage()));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<AddressModel?> _showAddressDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final line1Controller = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final zipController = TextEditingController();

    return showDialog<AddressModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
                TextField(controller: line1Controller, decoration: const InputDecoration(labelText: 'Address Line 1')),
                TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
                TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State')),
                TextField(controller: zipController, decoration: const InputDecoration(labelText: 'ZIP Code')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final address = AddressModel(
                  name: nameController.text.trim(),
                  line1: line1Controller.text.trim(),
                  city: cityController.text.trim(),
                  state: stateController.text.trim(),
                  zipCode: zipController.text.trim(),
                  country: 'Pakistan',
                  phone: phoneController.text.trim(),
                );
                Navigator.pop(context, address);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SuccessWidget(),
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CartController>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(item.product.imageUrl, width: 76, height: 76, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                const SizedBox(height: 4),
                Text(item.product.variant, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('PKR ${item.lineTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFF5C8A))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFEAF0), borderRadius: BorderRadius.circular(999)),
                      child: const Text('Save 10%', style: TextStyle(fontSize: 11, color: Color(0xFFFF5C8A), fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuantitySelector(itemId: item.id, quantity: item.quantity),
                    const SizedBox(width: 8),
                    TextButton(onPressed: () => controller.saveForLater(item.id), child: const Text('Save for later')),
                    TextButton(onPressed: () => controller.removeItem(item.id), child: const Text('Remove')),
                  ],
                ),
                if (!item.stockAvailable)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Currently out of stock', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedItemCard extends StatelessWidget {
  const SavedItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CartController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item.product.imageUrl, width: 56, height: 56, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                Text(item.product.formattedPrice, style: const TextStyle(color: Color(0xFFFF5C8A), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          TextButton(onPressed: () => controller.moveBackToCart(item.id), child: const Text('Move to Cart')),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key, required this.itemId, required this.quantity});

  final String itemId;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CartController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF7F3FF), borderRadius: BorderRadius.circular(999)),
      child: Row(
        children: [
          IconButton(onPressed: () => controller.updateQuantity(itemId, -1), icon: const Icon(Icons.remove, size: 16, color: Color(0xFF2F2148))),
          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          IconButton(onPressed: () => controller.updateQuantity(itemId, 1), icon: const Icon(Icons.add, size: 16, color: Color(0xFF2F2148))),
        ],
      ),
    );
  }
}

class CouponWidget extends StatelessWidget {
  CouponWidget({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Promo Code', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Try BABY10', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => controller.applyCoupon(_controller.text),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C8A), foregroundColor: Colors.white),
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (controller.couponMessage.isNotEmpty)
            Text(controller.couponMessage, style: TextStyle(color: controller.couponApplied ? Colors.green : Colors.red, fontSize: 12)),
          if (controller.couponApplied)
            TextButton(onPressed: controller.removeCoupon, child: const Text('Remove Coupon')),
        ],
      ),
    );
  }
}

class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({this.isCheckout = false, super.key});

  final bool isCheckout;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(
        children: [
          _row('Subtotal', controller.subtotal),
          _row('Delivery', controller.deliveryCharges),
          _row('Discount', -controller.discount),
          _row('Tax', controller.tax),
          const Divider(),
          _row('Grand Total', controller.grandTotal, isBold: true),
          const SizedBox(height: 8),
          if (isCheckout) ...[
            const Align(alignment: Alignment.centerLeft, child: Text('Address and payment are validated before order placement.', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF2F2148))),
          Text('PKR ${value.toStringAsFixed(0)}', style: TextStyle(fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF2F2148))),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address, required this.selected, required this.onSelect, required this.onDelete});

  final AddressModel address;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: selected ? const Color(0xFFFFEAF0) : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? const Color(0xFFFF5C8A) : const Color(0xFFF0E8F9))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.name, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                  const SizedBox(height: 4),
                  Text('${address.line1}, ${address.city}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(address.phone ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Color(0xFFFF5C8A))),
          ],
        ),
      ),
    );
  }
}

class DeliveryOptionCard extends StatelessWidget {
  const DeliveryOptionCard({super.key, required this.method, required this.selected, required this.onTap});

  final DeliveryMethodModel method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: selected ? const Color(0xFFEFF8FF) : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? const Color(0xFF5EA3FF) : const Color(0xFFF0E8F9))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                  const SizedBox(height: 4),
                  Text(method.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Text('PKR ${method.fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
          ],
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.method, required this.selected, required this.onTap});

  final PaymentMethodModel method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: selected ? const Color(0xFFF4EFFF) : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? const Color(0xFF7A3FE0) : const Color(0xFFF0E8F9))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
                  const SizedBox(height: 4),
                  Text(method.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: Color(0xFF7A3FE0)),
          ],
        ),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C8A), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key, this.onContinueShopping});

  final VoidCallback? onContinueShopping;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 86, color: Color(0xFFFF5C8A)),
            const SizedBox(height: 16),
            const Text('Your Cart is Empty', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
            const SizedBox(height: 8),
            const Text('Looks like you have not added anything to your cart yet.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            CheckoutButton(label: 'Continue Shopping', onPressed: onContinueShopping ?? () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message = 'Loading'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFFFF5C8A)),
          const SizedBox(height: 14),
          Text(message, style: const TextStyle(color: Color(0xFF2F2148), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFFE8F8EE), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_outline, size: 72, color: Color(0xFF2FAE6B)),
        ),
        const SizedBox(height: 20),
        const Text('Order Placed Successfully', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF2F2148))),
        const SizedBox(height: 8),
        const Text('Your order is confirmed and will be delivered soon.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        CheckoutButton(
          label: 'Track Order',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen(initialSearchQuery: 'BH78455', initialStatus: 'pending')),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Continue Shopping')),
      ],
    );
  }
}
