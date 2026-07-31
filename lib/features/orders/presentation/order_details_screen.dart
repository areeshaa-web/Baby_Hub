import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../models/tracking_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = order.statusEnum;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)]),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
            ),
          ),
        ),
        title: const Text('Order Details', style: TextStyle(color: Color(0xFF2B1A4A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(status),
            const SizedBox(height: 16),
            _buildInfoCard(order),
            const SizedBox(height: 16),
            _buildTimelineCard(order.trackingTimeline),
            const SizedBox(height: 16),
            _buildActionButtons(status, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(order.orderNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A)))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: status.badgeColor, borderRadius: BorderRadius.circular(999)),
                child: Text(status.label, style: TextStyle(color: status.textColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.orderDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMiniInfo(Icons.payment, order.payment.displayText),
              const SizedBox(width: 12),
              _buildMiniInfo(Icons.local_shipping_outlined, order.trackingNumber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String text) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFFF5C8A)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87), softWrap: true),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A))),
          const SizedBox(height: 12),
          _buildRow('Payment Method', order.payment.displayText),
          _buildRow('Shipping Address', order.address.formattedAddress),
          _buildRow('Customer', '${order.customerName}\n${order.customerPhone}'),
          _buildRow('Invoice Number', order.invoiceNumber),
          _buildRow('Coupon Discount', order.formattedDiscount),
          _buildRow('Delivery Charges', order.formattedDelivery),
          _buildRow('Tax', order.formattedTax),
          _buildRow('Grand Total', order.formattedTotal, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: const Color(0xFF2B1A4A)),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(List<TrackingModel> timeline) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tracking Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A))),
          const SizedBox(height: 12),
          ...timeline.map(_buildTimelineItem),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(TrackingModel item) {
    final isCompleted = item.isCompleted;
    final isCurrent = item.isCurrent;
    final color = isCompleted ? const Color(0xFF2FAE6B) : isCurrent ? const Color(0xFFFF5C8A) : Colors.grey.shade400;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            if (item != order.trackingTimeline.last) Container(height: 36, width: 2, color: color.withValues(alpha: 0.5)),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: TextStyle(fontWeight: FontWeight.w700, color: isCurrent ? const Color(0xFFFF5C8A) : const Color(0xFF2B1A4A)), softWrap: true),
                const SizedBox(height: 2),
                Text(item.timestamp, style: TextStyle(fontSize: 12, color: isCurrent ? const Color(0xFFFF5C8A) : Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(OrderStatus status, BuildContext context) {
    final primary = status == OrderStatus.processing
        ? ['Cancel Order', 'Contact Seller']
        : status == OrderStatus.shipped
            ? ['Track Package', 'Contact Delivery Partner']
            : ['Return Order', 'Write Review'];

    final colors = status == OrderStatus.processing
        ? [const Color(0xFFFFF1F5), const Color(0xFFF5F5F5)]
        : status == OrderStatus.shipped
            ? [const Color(0xFFF5F0FF), const Color(0xFFF5F5F5)]
            : [const Color(0xFFFFF1F5), const Color(0xFFF3F8F4)];

    final buttonColors = status == OrderStatus.processing
        ? [const Color(0xFFFF5C8A), const Color(0xFF2B1A4A)]
        : status == OrderStatus.shipped
            ? [const Color(0xFF7A3FE0), const Color(0xFF2B1A4A)]
            : [const Color(0xFFFF5C8A), const Color(0xFF2FAE6B)];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = constraints.maxWidth < 420;
        if (useColumn) {
          return Column(
            children: [
              SizedBox(width: double.infinity, child: _actionButton(primary[0], colors[0], buttonColors[0], () {})),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: _actionButton(primary[1], colors[1], buttonColors[1], () {})),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _actionButton(primary[0], colors[0], buttonColors[0], () {})),
            const SizedBox(width: 10),
            Expanded(child: _actionButton(primary[1], colors[1], buttonColors[1], () {})),
          ],
        );
      },
    );
  }

  Widget _actionButton(String label, Color bg, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: color, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      onPressed: onPressed,
      child: FittedBox(
        child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
