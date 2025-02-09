import 'counterparty.dart';

class TopSupplierPrice {
  final Counterparty supplier;
  final double price;
  final DateTime priceForDate;

  TopSupplierPrice({
    required this.supplier,
    required this.price,
    required this.priceForDate,
  });

  /// 🔄 Преобразование JSON в объект
  factory TopSupplierPrice.fromJson(Map<String, dynamic> json) {
    return TopSupplierPrice(
      supplier: Counterparty.fromJson(json['supplier']),
      price: json['price'] is String
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] as num).toDouble(),
      priceForDate: DateTime.parse(json['price_for_date']),
    );
  }

  /// 🔄 Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'supplier': supplier.toJson(),
      'price': price,
      'price_for_date': priceForDate.toIso8601String(),
    };
  }
}
