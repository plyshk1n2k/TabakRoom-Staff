import 'product.dart';
import 'warehouse.dart';

class ProductPurchasePriority {
  final int id;
  final Product product;
  final Warehouse warehouse;
  final int totalSalesLast30Days;
  final int totalSalesLast7Days;
  final int currentStock;
  final int stockCoverageDays;
  final String priorityLevel;
  final DateTime lastUpdated;

  ProductPurchasePriority({
    required this.id,
    required this.product,
    required this.warehouse,
    required this.totalSalesLast30Days,
    required this.totalSalesLast7Days,
    required this.currentStock,
    required this.stockCoverageDays,
    required this.priorityLevel,
    required this.lastUpdated,
  });

  /// 🔄 Преобразование JSON в объект
  factory ProductPurchasePriority.fromJson(Map<String, dynamic> json) {
    return ProductPurchasePriority(
      id: json['id'],
      product: Product.fromJson(json['product']),
      warehouse: Warehouse.fromJson(json['warehouse']),
      totalSalesLast30Days: json['total_sales_last_30_days'],
      totalSalesLast7Days: json['total_sales_last_7_days'],
      currentStock: json['current_stock'],
      stockCoverageDays: json['stock_coverage_days'],
      priorityLevel: json['priority_level'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  /// 🔄 Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'warehouse': warehouse.toJson(),
      'total_sales_last_30_days': totalSalesLast30Days,
      'total_sales_last_7_days': totalSalesLast7Days,
      'current_stock': currentStock,
      'stock_coverage_days': stockCoverageDays,
      'priority_level': priorityLevel,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
