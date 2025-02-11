import 'package:tabakroom_staff/models/top_supplier_price.dart';

class OrderRecommendation {
  final TopSupplierPrice strategyPrice; // Цена по стратегии
  final TopSupplierPrice top1Price; // Самая низкая цена

  OrderRecommendation({
    required this.strategyPrice,
    required this.top1Price,
  });

  /// 🔄 Преобразование JSON в объект
  factory OrderRecommendation.fromJson(Map<String, dynamic> json) {
    return OrderRecommendation(
      strategyPrice: TopSupplierPrice.fromJson(json['strategy_price']),
      top1Price: TopSupplierPrice.fromJson(json['top1_price']),
    );
  }

  /// 🔄 Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'strategy_price': strategyPrice.toJson(),
      'top1_price': top1Price.toJson(),
    };
  }
}
