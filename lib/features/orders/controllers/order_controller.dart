import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_repository.dart';

class OrderController extends ChangeNotifier {
  OrderController({OrderRepository? repository}) : _repository = repository ?? OrderRepository();

  final OrderRepository _repository;

  bool isLoading = false;
  bool isRefreshing = false;
  bool hasError = false;
  String errorMessage = '';
  String selectedStatus = 'all';
  String searchQuery = '';
  String sortOrder = 'latest';
  List<OrderModel> _orders = [];
  List<OrderModel> _allOrders = [];
  bool hasMore = true;
  int page = 1;
  static const int pageSize = 5;

  List<OrderModel> get orders => _filteredOrders;

  List<OrderModel> get _filteredOrders {
    var result = List<OrderModel>.from(_orders);

    if (selectedStatus != 'all') {
      result = result.where((order) => order.status.toLowerCase() == selectedStatus).toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((order) {
        return order.orderNumber.toLowerCase().contains(query) ||
            order.trackingNumber.toLowerCase().contains(query) ||
            order.products.any((product) => product.name.toLowerCase().contains(query));
      }).toList();
    }

    result.sort((a, b) {
      final aDate = _parseOrderDate(a.orderDate);
      final bDate = _parseOrderDate(b.orderDate);
      return sortOrder == 'latest' ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });

    return result;
  }

  DateTime _parseOrderDate(String value) {
    final match = RegExp(r'(\d{1,2})\s+([A-Za-z]{3}),\s*(\d{4})').firstMatch(value);
    if (match == null) {
      return DateTime.now();
    }

    final day = int.parse(match.group(1)!);
    final month = _monthNumber(match.group(2)!);
    final year = int.parse(match.group(3)!);
    return DateTime(year, month, day);
  }

  int _monthNumber(String month) {
    const months = <String, int>{
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return months[month] ?? 1;
  }

  Future<void> loadOrders({bool refresh = false, bool force = false}) async {
    if (refresh) {
      isRefreshing = true;
      page = 1;
      hasMore = true;
      notifyListeners();
    } else if (isLoading && !force) {
      return;
    }

    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    try {
      final fetched = await _repository.getOrders(
        status: selectedStatus == 'all' ? null : selectedStatus,
        page: page,
        pageSize: pageSize,
      );

      if (refresh || page == 1) {
        _orders = fetched;
        _allOrders = fetched;
      } else {
        _orders.addAll(fetched);
        _allOrders.addAll(fetched);
      }

      hasMore = fetched.length >= pageSize;
      page += 1;
    } catch (e) {
      hasError = true;
      errorMessage = 'We could not load your orders right now.';
    } finally {
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    await loadOrders();
  }

  Future<void> setStatus(String value) async {
    selectedStatus = value;
    page = 1;
    hasMore = true;
    _orders = [];
    notifyListeners();
    await loadOrders(force: true);
  }

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setSort(String value) {
    sortOrder = value;
    notifyListeners();
  }

  Future<OrderModel?> fetchOrderDetails(String orderId) async {
    return _repository.getOrderDetails(orderId);
  }

  Future<bool> cancelOrder(String orderId) async {
    return _repository.cancelOrder(orderId);
  }

  Future<bool> returnOrder(String orderId) async {
    return _repository.returnOrder(orderId);
  }

  Future<bool> reorder(String orderId) async {
    return _repository.reorder(orderId);
  }

  Future<Map<String, dynamic>> trackOrder(String orderId) async {
    return _repository.trackOrder(orderId);
  }
}
