import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/order_controller.dart';
import '../models/order_model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, this.initialSearchQuery, this.initialStatus});

  final String? initialSearchQuery;
  final String? initialStatus;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderController()..loadOrders(),
      child: _OrdersBody(initialSearchQuery: initialSearchQuery, initialStatus: initialStatus),
    );
  }
}

class _OrdersBody extends StatefulWidget {
  const _OrdersBody({this.initialSearchQuery, this.initialStatus});

  final String? initialSearchQuery;
  final String? initialStatus;

  @override
  State<_OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<_OrdersBody> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  late final int _initialTabIndex;
  final List<String> _tabs = ['all', 'pending', 'processing', 'shipped', 'delivered'];
  final List<String> _labels = ['All Orders', 'Pending', 'Processing', 'Shipped', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _initialTabIndex = _tabs.indexOf(widget.initialStatus ?? 'all');
    if (_initialTabIndex < 0) {
      _initialTabIndex = 0;
    }
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: _initialTabIndex);
    _tabController.addListener(_handleTabChange);
    _searchController = TextEditingController(text: widget.initialSearchQuery ?? '');
    _searchController.addListener(_handleSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if ((widget.initialSearchQuery ?? '').isNotEmpty) {
        context.read<OrderController>().setSearch(widget.initialSearchQuery!);
      }
      if (widget.initialStatus != null) {
        context.read<OrderController>().setStatus(widget.initialStatus!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      context.read<OrderController>().setStatus(_tabs[_tabController.index]);
    }
  }

  void _handleSearchChanged() {
    context.read<OrderController>().setSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => context.read<OrderController>().setSearch(_searchController.text),
                          decoration: const InputDecoration(
                            hintText: 'Search by order code or product',
                            prefixIcon: Icon(Icons.search, color: Color(0xFFFF5C8A)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
                        child: const Icon(Icons.sort_rounded, color: Color(0xFF2B1A4A)),
                      ),
                      onSelected: (value) {
                        context.read<OrderController>().setSort(value);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'latest', child: Text('Latest first')),
                        PopupMenuItem(value: 'oldest', child: Text('Oldest first')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    onTap: (_) => _handleTabChange(),
                    indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(985), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6)]),
                    labelColor: const Color(0xFFFF5C8A),
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: -2),
                    tabAlignment: TabAlignment.start,
                    tabs: List.generate(_tabs.length, (index) {
                      final label = _labels[index];
                      return Tab(
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                index == 0
                                    ? Icons.list_alt
                                    : index == 1
                                        ? Icons.pending_actions_outlined
                                        : index == 2
                                            ? Icons.hourglass_bottom
                                            : index == 3
                                                ? Icons.local_shipping_outlined
                                                : Icons.celebration_outlined,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(label),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<OrderController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.orders.isEmpty) {
            return _buildLoadingState();
          }
          if (controller.hasError) {
            return _buildErrorState(controller, context);
          }
          if (controller.orders.isEmpty) {
            return controller.searchQuery.isNotEmpty ? _buildNoResultsState(context, controller.searchQuery) : _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () => controller.loadOrders(refresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: controller.orders.length + (controller.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.orders.length) {
                  controller.loadMore();
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFFFF5C8A))),
                  );
                }
                return _OrderCard(order: controller.orders[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 220,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildErrorState(OrderController controller, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 72, color: Color(0xFFFF5C8A)),
          const SizedBox(height: 12),
          Text(controller.errorMessage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => controller.loadOrders(refresh: true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C8A), foregroundColor: Colors.white),
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No Orders Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A))),
            const SizedBox(height: 8),
            const Text('Your order history will appear here once you begin shopping.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C8A), foregroundColor: Colors.white),
              child: const Text('Continue Shopping'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context, String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No Matching Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A))),
            const SizedBox(height: 8),
            Text('Try a different code such as $query or check your spelling.', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = order.statusEnum;
    final product = order.products.first;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A), fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(order.orderDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('Track code: ${order.trackingNumber}', style: const TextStyle(fontSize: 11, color: Color(0xFFFF5C8A), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: status.badgeColor, borderRadius: BorderRadius.circular(999)),
                        child: Text(status.label, style: TextStyle(color: status.textColor, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, softWrap: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.image_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2B1A4A)), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(product.variant, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Text('Qty ${product.quantity}', style: const TextStyle(color: Color(0xFFFF5C8A), fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 70),
                      child: Text(product.formattedPrice, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A), fontSize: 13), textAlign: TextAlign.right, maxLines: 2),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: status.infoBackground, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Icon(status.infoIcon, color: status.textColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status == OrderStatus.processing
                                  ? 'Order is being prepared'
                                  : status == OrderStatus.shipped
                                      ? 'Order is shipped and moving to you'
                                      : 'Delivered on ${order.deliveredDate}',
                              style: TextStyle(fontWeight: FontWeight.w700, color: status.textColor, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              status == OrderStatus.processing
                                  ? 'Expected to be ready soon'
                                  : status == OrderStatus.shipped
                                      ? 'Expected delivery: ${order.expectedDate}'
                                      : 'Thank you for shopping with BabyHub!',
                              style: TextStyle(fontSize: 12, color: status.textColor.withValues(alpha: 0.9)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(order.formattedTotal, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B1A4A), fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
