import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import '../models/product_purchase_priority.dart';
import '../services/api_service.dart';

class PurchasePriorityService {
  /// Получение списка приоритетных товаров с учетом фильтров
  static Future<ApiResponse<List<ProductPurchasePriority>>>
      fetchPrioritiesProducts({
    FilterOptions? filter,
  }) async {
    final queryParams = filter
            ?.toJson()
            .map((key, value) => MapEntry(key, value.toString()))
            .cast<String, String>() ??
        {};

    queryParams.removeWhere((key, value) => value.isEmpty);

    final uri = Uri.parse('/purchase-priorities/')
        .replace(queryParameters: queryParams);

    final response = await ApiService.get<List<dynamic>>(uri.toString());

    return response.isSuccess
        ? ApiResponse.success(response.data!
            .map((item) => ProductPurchasePriority.fromJson(item))
            .toList())
        : ApiResponse.error(response.error);
  }

  /// Получение списка уникальных приоритетов
  static Future<ApiResponse<List<String>>> fetchPriorities() async {
    final response = await ApiService.get<List<dynamic>>('/unique-priorities/');

    return response.isSuccess
        ? ApiResponse.success(
            response.data!.map((item) => item.toString()).toList())
        : ApiResponse.error(response.error);
  }

  /// Получение списка складов
  static Future<ApiResponse<List<Warehouse>>> fetchWarehouses() async {
    final response = await ApiService.get<List<dynamic>>('/warehouses/');

    return response.isSuccess
        ? ApiResponse.success(
            response.data!.map((item) => Warehouse.fromJson(item)).toList())
        : ApiResponse.error(response.error);
  }

  /// Получение списка категорий товаров
  static Future<ApiResponse<List<ProductCategories>>>
      fetchProductCategories() async {
    final response = await ApiService.get<List<dynamic>>('/product-groups/');

    return response.isSuccess
        ? ApiResponse.success(response.data!
            .map((item) => ProductCategories.fromJson(item))
            .toList())
        : ApiResponse.error(response.error);
  }
}
