import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/order_recommendation.dart';
import '../services/api_service.dart';

class OrderRecommendationService {
  /// Получение рекомендаций по заказу на основе выбранных товаров и стратегии
  static Future<ApiResponse<List<OrderRecommendation>>> fetchRecommendations({
    required List<int> selectedProducts,
    required String strategy,
  }) async {
    final uri = Uri.parse('/order-recommendations/');

    final response = await ApiService.post<List<dynamic>>(
      uri.toString(),
      {
        "selected_products": selectedProducts,
        "strategy": strategy,
      },
    );

    return response.isSuccess
        ? ApiResponse.success(response.data!
            .map((item) => OrderRecommendation.fromJson(item))
            .toList())
        : ApiResponse.error(response.error);
  }
}
