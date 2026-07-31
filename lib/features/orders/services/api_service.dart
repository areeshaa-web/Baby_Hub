import 'package:flutter/foundation.dart';

import '../models/address_model.dart';
import '../models/order_model.dart';
import '../models/payment_model.dart';
import '../models/product_model.dart';
import '../models/tracking_model.dart';

class ApiService {
  Future<List<OrderModel>> getOrders({String? status, int page = 1, int pageSize = 5}) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final List<OrderModel> allOrders = [
      OrderModel(
        id: '1',
        orderNumber: 'BH78452',
        orderDate: '24 Jul, 2026 • 10:30 AM',
        status: 'processing',
        products: const [
          ProductModel(
            id: 'p1',
            name: 'Cotton Romper Set',
            variant: 'Size 6M',
            quantity: 1,
            price: 1650,
            imageUrl: 'https://alayajunior.com/cdn/shop/files/Carters-Pack-Of-3-Baby-Rompers-Bear-And-Stars-Beige.webp?v=1768772145&width=1445',
          ),
        ],
        address: const AddressModel(
          name: 'Ayesha Khan',
          line1: 'House 12, Gulberg 3',
          city: 'Lahore',
          state: 'Punjab',
          zipCode: '54000',
          country: 'Pakistan',
          phone: '+92 300 1234567',
        ),
        payment: const PaymentModel(method: 'Cash on Delivery', status: 'Pending'),
        invoiceNumber: 'INV-20260724-001',
        trackingNumber: 'TRK-78452',
        couponDiscount: 150,
        deliveryCharges: 200,
        tax: 80,
        totalAmount: 1780,
        expectedDate: '28 Jul, 2026',
        deliveredDate: '',
        customerName: 'Ayesha Khan',
        customerPhone: '+92 300 1234567',
        customerEmail: 'ayesha@example.com',
        trackingTimeline: const [
          TrackingModel(title: 'Order Placed', timestamp: '24 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Processing', timestamp: '25 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Packed', timestamp: '26 Jul', isCompleted: false, isCurrent: true),
          TrackingModel(title: 'Shipped', timestamp: '27 Jul', isCompleted: false, isCurrent: false),
          TrackingModel(title: 'Out for Delivery', timestamp: '28 Jul', isCompleted: false, isCurrent: false),
          TrackingModel(title: 'Delivered', timestamp: '29 Jul', isCompleted: false, isCurrent: false),
        ],
      ),
      OrderModel(
        id: '2',
        orderNumber: 'BH78453',
        orderDate: '22 Jul, 2026 • 04:15 PM',
        status: 'shipped',
        products: const [
          ProductModel(
            id: 'p2',
            name: 'Soft Teddy Bear',
            variant: 'Cream',
            quantity: 2,
            price: 1250,
            imageUrl: 'https://toyshutch.pk/cdn/shop/files/soft-stuffed-teddy-bear-with-cap-101905.webp?v=1778759066',
          ),
        ],
        address: const AddressModel(
          name: 'Sara Malik',
          line1: 'Flat 8, DHA',
          city: 'Islamabad',
          state: 'Islamabad',
          zipCode: '44000',
          country: 'Pakistan',
          phone: '+92 320 9876543',
        ),
        payment: const PaymentModel(method: 'Card', status: 'Paid', cardLast4: '4821'),
        invoiceNumber: 'INV-20260722-002',
        trackingNumber: 'TRK-78453',
        couponDiscount: 0,
        deliveryCharges: 250,
        tax: 120,
        totalAmount: 2620,
        expectedDate: '26 Jul, 2026',
        deliveredDate: '',
        customerName: 'Sara Malik',
        customerPhone: '+92 320 9876543',
        customerEmail: 'sara@example.com',
        trackingTimeline: const [
          TrackingModel(title: 'Order Placed', timestamp: '22 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Processing', timestamp: '23 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Packed', timestamp: '24 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Shipped', timestamp: '25 Jul', isCompleted: true, isCurrent: true),
          TrackingModel(title: 'Out for Delivery', timestamp: '26 Jul', isCompleted: false, isCurrent: false),
          TrackingModel(title: 'Delivered', timestamp: '27 Jul', isCompleted: false, isCurrent: false),
        ],
      ),
      OrderModel(
        id: '3',
        orderNumber: 'BH78454',
        orderDate: '18 Jul, 2026 • 08:45 AM',
        status: 'delivered',
        products: const [
          ProductModel(
            id: 'p3',
            name: 'Baby Bottle Set',
            variant: 'Blue',
            quantity: 1,
            price: 1480,
            imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=500&q=80',
          ),
        ],
        address: const AddressModel(
          name: 'Muneeb Ali',
          line1: 'Street 9, Model Town',
          city: 'Karachi',
          state: 'Sindh',
          zipCode: '75200',
          country: 'Pakistan',
          phone: '+92 333 4567890',
        ),
        payment: const PaymentModel(method: 'Easypaisa', status: 'Paid'),
        invoiceNumber: 'INV-20260718-003',
        trackingNumber: 'TRK-78454',
        couponDiscount: 250,
        deliveryCharges: 0,
        tax: 100,
        totalAmount: 1330,
        expectedDate: '20 Jul, 2026',
        deliveredDate: '20 Jul, 2026',
        customerName: 'Muneeb Ali',
        customerPhone: '+92 333 4567890',
        customerEmail: 'muneeb@example.com',
        trackingTimeline: const [
          TrackingModel(title: 'Order Placed', timestamp: '18 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Processing', timestamp: '19 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Packed', timestamp: '19 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Shipped', timestamp: '20 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Out for Delivery', timestamp: '20 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Delivered', timestamp: '20 Jul', isCompleted: true, isCurrent: true),
        ],
      ),
      OrderModel(
        id: '4',
        orderNumber: 'BH78455',
        orderDate: '30 Jul, 2026 • 11:20 AM',
        status: 'pending',
        products: const [
          ProductModel(
            id: 'p4',
            name: 'Baby Bottle Set',
            variant: 'Pink',
            quantity: 1,
            price: 1480,
            imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=500&q=80',
          ),
        ],
        address: const AddressModel(
          name: 'Ayesha Khan',
          line1: 'House 12, Gulberg 3',
          city: 'Lahore',
          state: 'Punjab',
          zipCode: '54000',
          country: 'Pakistan',
          phone: '+92 300 1234567',
        ),
        payment: const PaymentModel(method: 'Cash on Delivery', status: 'Pending'),
        invoiceNumber: 'INV-20260730-004',
        trackingNumber: 'TRK-78455',
        couponDiscount: 0,
        deliveryCharges: 200,
        tax: 100,
        totalAmount: 1780,
        expectedDate: '03 Aug, 2026',
        deliveredDate: '',
        customerName: 'Ayesha Khan',
        customerPhone: '+92 300 1234567',
        customerEmail: 'ayesha@example.com',
        trackingTimeline: const [
          TrackingModel(title: 'Order Placed', timestamp: '30 Jul', isCompleted: true, isCurrent: false),
          TrackingModel(title: 'Processing', timestamp: '31 Jul', isCompleted: true, isCurrent: true),
          TrackingModel(title: 'Packed', timestamp: '01 Aug', isCompleted: false, isCurrent: false),
          TrackingModel(title: 'Shipped', timestamp: '02 Aug', isCompleted: false, isCurrent: false),
          TrackingModel(title: 'Delivered', timestamp: '03 Aug', isCompleted: false, isCurrent: false),
        ],
      ),
    ];

    final filtered = status == null || status.isEmpty
        ? allOrders
        : allOrders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();

    return filtered.skip((page - 1) * pageSize).take(pageSize).toList();
  }

  Future<OrderModel?> getOrderDetails(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final orders = await getOrders();
    return orders.where((order) => order.id == orderId).cast<OrderModel?>().firstOrNull();
  }

  Future<bool> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    debugPrint('Cancelled $orderId');
    return true;
  }

  Future<bool> returnOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    debugPrint('Returned $orderId');
    return true;
  }

  Future<bool> reorder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    debugPrint('Reordered $orderId');
    return true;
  }

  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return {'orderId': orderId, 'status': 'In Transit', 'updatedAt': 'Today'};
  }
}

extension on Iterable<OrderModel?> {
  OrderModel? firstOrNull() => isEmpty ? null : first;
}
