import 'package:tabakroom_staff/models/api_response.dart';
import 'package:flutter/foundation.dart';
import '../models/product_purchase_priority.dart';
import '../services/api_service.dart';

class PurchasePriorityService {
  static Future<ApiResponse<List<ProductPurchasePriority>>>
      fetchPriorities() async {
    try {
      final response =
          await ApiService.get('/purchase-priorities/', rethrowError: false);
      return ApiResponse.success((response as List)
          .map((item) => ProductPurchasePriority.fromJson(item))
          .toList());
    } catch (e) {
      debugPrint('Ошибка получения данных: $e');
      return ApiResponse.error('Ошибка получения данных!');
    }
  }
}
