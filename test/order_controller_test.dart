import 'package:flutter_test/flutter_test.dart';
import 'package:project/features/orders/controllers/order_controller.dart';

void main() {
  test('pending status and search both work for the new order flow', () async {
    final controller = OrderController();
    await controller.loadOrders(force: true);

    await controller.setStatus('pending');
    expect(controller.orders.any((order) => order.status == 'pending'), isTrue);

    controller.setSearch('BH78455');
    expect(controller.orders.any((order) => order.orderNumber == 'BH78455'), isTrue);

    controller.setSearch('TRK-78455');
    expect(controller.orders.any((order) => order.trackingNumber == 'TRK-78455'), isTrue);
  });
}
