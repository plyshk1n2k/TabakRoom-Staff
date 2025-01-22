import 'package:tabakroom_staff/models/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import '../models/product_purchase_priority.dart';
import '../services/api_service.dart';

class PurchasePriorityService {
  static Future<ApiResponse<List<ProductPurchasePriority>>>
      fetchPrioritiesProducts({
    FilterOptions? filter,
  }) async {
    try {
      // Преобразуем фильтр в Map и удаляем пустые параметры
      final Map<String, dynamic> queryParams = filter
              ?.toJson()
              .map((key, value) =>
                  MapEntry(key, value.toString())) // Приведение к строке
              .cast<String, String>() ??
          {};

      // Удаляем параметры с пустыми значениями
      queryParams.removeWhere((key, value) => value.isEmpty);

      // Генерация строки запроса с параметрами
      final uri = Uri.parse('/purchase-priorities/')
          .replace(queryParameters: queryParams);

      // Запрос с параметрами
      final response =
          await ApiService.get(uri.toString(), rethrowError: false);

      return ApiResponse.success((response as List)
          .map((item) => ProductPurchasePriority.fromJson(item))
          .toList());
    } catch (e) {
      debugPrint('Ошибка получения данных: $e');
      return ApiResponse.error('Ошибка получения данных!');
    }
  }

  static Future<ApiResponse<List<String>>> fetchPriorities() async {
    try {
      final response =
          await ApiService.get('/unique-priorities/', rethrowError: false);

      // Проверка, что ответ - это список
      if (response is List) {
        final priorities = response.map((item) => item.toString()).toList();
        return ApiResponse.success(priorities);
      } else {
        return ApiResponse.error('Некорректный формат данных от сервера');
      }
    } catch (e) {
      debugPrint('Ошибка получения данных о приоритетах: $e');
      return ApiResponse.error(
          'Ошибка получения данных для фильтрации приоритетов!');
    }
  }

  static Future<ApiResponse<List<Warehouse>>> fetchWarehouses() async {
    try {
      final response =
          await ApiService.get('/warehouses/', rethrowError: false);

      // Проверка, что ответ - это список
      if (response is List) {
        return ApiResponse.success(
            (response).map((item) => Warehouse.fromJson(item)).toList());
      } else {
        return ApiResponse.error('Некорректный формат данных от сервера');
      }
    } catch (e) {
      debugPrint('Ошибка получения данных о складах: $e');
      return ApiResponse.error(
          'Ошибка получения данных для фильтрации складов!');
    }
  }

  static Future<ApiResponse<List<ProductCategories>>>
      fetchProductCategories() async {
    try {
      final response =
          await ApiService.get('/product-groups/', rethrowError: false);

      // Проверка, что ответ - это список
      if (response is List) {
        return ApiResponse.success((response)
            .map((item) => ProductCategories.fromJson(item))
            .toList());
      } else {
        return ApiResponse.error('Некорректный формат данных от сервера');
      }
    } catch (e) {
      debugPrint('Ошибка получения данных о категориях товаров: $e');
      return ApiResponse.error(
          'Ошибка получения данных для фильтрации категорий товаров!');
    }
  }
}
