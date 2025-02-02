import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/detect_suspicious_bonus.dart';
import '../services/api_service.dart';

class SuspiciousTransactionsService {
  /// Получение списка подозрительных транзакций с учетом фильтра
  static Future<ApiResponse<List<DetectSuspiciousBonus>>>
      fetchSuspiciousTransactions({
    FilterOptions? filter,
  }) async {
    final queryParams = filter
            ?.toJson()
            .map((key, value) => MapEntry(key, value.toString()))
            .cast<String, String>() ??
        {};

    queryParams.removeWhere((key, value) => value.isEmpty);

    final uri = Uri.parse('/detect-bonus-suspicious/')
        .replace(queryParameters: queryParams);

    final response = await ApiService.get<List<dynamic>>(uri.toString());

    return response.isSuccess
        ? ApiResponse.success(response.data!
            .map((item) => DetectSuspiciousBonus.fromJson(item))
            .toList())
        : ApiResponse.error(response.error);
  }

  /// Отметка инцидента как проверенного
  static Future<ApiResponse<Map<String, dynamic>>> markIncidentReviewed({
    required int incidentId,
  }) async {
    final requestBody = {'incident_id': incidentId};

    final response = await ApiService.post<Map<String, dynamic>>(
        '/incidents/review/', requestBody);

    return response.isSuccess
        ? ApiResponse.success(response.data!)
        : ApiResponse.error(response.error);
  }
}
