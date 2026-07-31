import 'package:flutter/material.dart';

import 'address_model.dart';
import 'payment_model.dart';
import 'product_model.dart';
import 'tracking_model.dart';

enum OrderStatus { pending, processing, shipped, delivered }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
    }
  }

  Color get badgeColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFF1F5);
      case OrderStatus.processing:
        return const Color(0xFFFFF7E5);
      case OrderStatus.shipped:
        return const Color(0xFFF2E9FF);
      case OrderStatus.delivered:
        return const Color(0xFFE8F8EE);
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFF5C8A);
      case OrderStatus.processing:
        return const Color(0xFFFFC107);
      case OrderStatus.shipped:
        return const Color(0xFF7A3FE0);
      case OrderStatus.delivered:
        return const Color(0xFF2FAE6B);
    }
  }

  Color get infoBackground {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFF0F4);
      case OrderStatus.processing:
        return const Color(0xFFFFF7D9);
      case OrderStatus.shipped:
        return const Color(0xFFF3ECFF);
      case OrderStatus.delivered:
        return const Color(0xFFE9F8ED);
    }
  }

  IconData get infoIcon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.pending_actions_outlined;
      case OrderStatus.processing:
        return Icons.inventory_2_outlined;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
    }
  }
}

OrderStatus parseOrderStatus(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'pending':
      return OrderStatus.pending;
    case 'processing':
      return OrderStatus.processing;
    case 'shipped':
      return OrderStatus.shipped;
    case 'delivered':
      return OrderStatus.delivered;
    default:
      return OrderStatus.pending;
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.products,
    required this.address,
    required this.payment,
    required this.invoiceNumber,
    required this.trackingNumber,
    required this.couponDiscount,
    required this.deliveryCharges,
    required this.tax,
    required this.totalAmount,
    required this.expectedDate,
    required this.deliveredDate,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.trackingTimeline,
  });

  final String id;
  final String orderNumber;
  final String orderDate;
  final String status;
  final List<ProductModel> products;
  final AddressModel address;
  final PaymentModel payment;
  final String invoiceNumber;
  final String trackingNumber;
  final double couponDiscount;
  final double deliveryCharges;
  final double tax;
  final double totalAmount;
  final String expectedDate;
  final String deliveredDate;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<TrackingModel> trackingTimeline;

  OrderStatus get statusEnum => parseOrderStatus(status);

  String get formattedTotal => 'PKR ${totalAmount.toStringAsFixed(0)}';
  String get formattedDiscount => 'PKR ${couponDiscount.toStringAsFixed(0)}';
  String get formattedDelivery => 'PKR ${deliveryCharges.toStringAsFixed(0)}';
  String get formattedTax => 'PKR ${tax.toStringAsFixed(0)}';
}
