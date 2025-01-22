import 'package:tabakroom_staff/models/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:tabakroom_staff/models/detect_suspicious_bonus.dart';
import '../services/api_service.dart';

class SuspiciousTransactionsService {
  static Future<ApiResponse<List<DetectSuspiciousBonus>>>
      fetchSuspiciousTransactions({
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
      final uri = Uri.parse('/detect-bonus-suspicious/')
          .replace(queryParameters: queryParams);

      // Запрос с параметрами
      final response =
          await ApiService.get(uri.toString(), rethrowError: false);

      return ApiResponse.success((response as List)
          .map((item) => DetectSuspiciousBonus.fromJson(item))
          .toList());
    } catch (e) {
      debugPrint('Ошибка получения данных: $e');
      return ApiResponse.error('Ошибка получения данных!');
    }
  }

  static Future<ApiResponse> markIncidentReviewed({
    required int incidentId,
  }) async {
    try {
      // Формируем тело запроса
      final Map<String, dynamic> requestBody = {
        'incident_id': incidentId,
      };

      // Отправляем POST-запрос
      final response = await ApiService.post(
        '/incidents/review/', // Укажите правильный путь к вашему API
        requestBody,
        rethrowError: false,
      );

      if (response != null && response['message'] != null) {
        debugPrint('Инцидент успешно отмечен как проверенный.');
        return ApiResponse.success(response);
      } else {
        debugPrint('Не удалось отметить инцидент: ${response.toString()}');
        return ApiResponse.error(
            'Ошибка при отметке инцидента как проверенного.');
      }
    } catch (e) {
      debugPrint('Ошибка запроса: $e');
      return ApiResponse.error('Ошибка запроса.');
    }
  }
}
