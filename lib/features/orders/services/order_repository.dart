import '../models/order_model.dart';
import 'api_service.dart';

class OrderRepository {
  OrderRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<OrderModel>> getOrders({String? status, int page = 1, int pageSize = 5}) {
    return _apiService.getOrders(status: status, page: page, pageSize: pageSize);
  }

  Future<OrderModel?> getOrderDetails(String orderId) => _apiService.getOrderDetails(orderId);

  Future<bool> cancelOrder(String orderId) => _apiService.cancelOrder(orderId);

  Future<bool> returnOrder(String orderId) => _apiService.returnOrder(orderId);

  Future<bool> reorder(String orderId) => _apiService.reorder(orderId);

  Future<Map<String, dynamic>> trackOrder(String orderId) => _apiService.trackOrder(orderId);
}
