import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/top_supplier_price.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import '../models/product_purchase_priority.dart';
import '../services/api_service.dart';

class PurchasePriorityService {
  /// Получение списка приоритетных товаров с учетом фильтров
  static Future<ApiResponse<List<ProductPurchasePriority>>>
      fetchPrioritiesProducts({
    FilterOptions? filter,
  }) async {
    final Map<String, List<String>> queryParams = {};

    if (filter != null) {
      final Map<String, dynamic> filterJson = filter.toJson();
      filterJson.forEach((key, value) {
        if (value != null) {
          if (value is List && value.isNotEmpty) {
            queryParams[key] = value.map((v) => v.toString()).toList();
          } else if (value is! List && value.toString().isNotEmpty) {
            queryParams[key] = [value.toString()];
          }
        }
      });
    }

    final uri = Uri.parse('/purchase-priorities/').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

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

  /// Получение списка топовых
  static Future<ApiResponse<List<TopSupplierPrice>>> fetchTopPriceSupplier(
      int productId,
      {int? warehouseId}) async {
    // Добавляем warehouseId в query параметры, если он есть
    final uri = Uri.parse('/supplier-prices/$productId').replace(
      queryParameters:
          warehouseId != null ? {'warehouse_id': warehouseId.toString()} : {},
    );

    final response = await ApiService.get<List<dynamic>>(uri.toString());

    return response.isSuccess
        ? ApiResponse.success(response.data!
            .map((item) => TopSupplierPrice.fromJson(item))
            .toList())
        : ApiResponse.error(response.error);
  }
}
