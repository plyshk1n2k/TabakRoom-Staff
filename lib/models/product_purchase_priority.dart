import 'package:tabakroom_staff/services/app_preferences.dart';
import 'product.dart';
import 'warehouse.dart';

class ProductPurchasePriority {
  final int id;
  final Product product;
  final Warehouse warehouse;
  final int totalSalesLast180Days;
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
    required this.totalSalesLast180Days,
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
      totalSalesLast180Days: json['total_sales_last_180_days'],
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
      'total_sales_last_180_days': totalSalesLast180Days,
      'total_sales_last_30_days': totalSalesLast30Days,
      'total_sales_last_7_days': totalSalesLast7Days,
      'current_stock': currentStock,
      'stock_coverage_days': stockCoverageDays,
      'priority_level': priorityLevel,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class FilterOptions {
  String? _priorityLevel; // Закрытое поле для уровня приоритета
  int? _warehouseId; // Закрытое поле для ID склада
  int? _groupId; // Закрытое поле для ID группы

  // Геттеры для доступа к значениям
  String? get priorityLevel => _priorityLevel;
  int? get warehouseId => _warehouseId;
  int? get groupId => _groupId;

  // Сеттеры с автоматическим сохранением
  set priorityLevel(String? value) {
    _priorityLevel = value;
    _saveToPreferences();
  }

  set warehouseId(int? value) {
    _warehouseId = value;
    _saveToPreferences();
  }

  set groupId(int? value) {
    _groupId = value;
    _saveToPreferences();
  }

  // Конструктор
  FilterOptions({
    String? priorityLevel,
    int? warehouseId,
    int? groupId,
  })  : _priorityLevel = priorityLevel,
        _warehouseId = warehouseId,
        _groupId = groupId;

  // Конструктор из JSON
  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      priorityLevel: json['priority_level'],
      warehouseId: json['warehouse_id'],
      groupId: json['group_id'],
    );
  }

  // Асинхронный фабричный конструктор для загрузки данных из SharedPreferences
  static Future<FilterOptions> loadFromPreferences() async {
    final json = await AppPreferences.getValue<Map<String, dynamic>>(
        'product_filter_options');
    if (json != null) {
      return FilterOptions.fromJson(json);
    }
    return FilterOptions(); // Возвращаем объект с дефолтными значениями
  }

  // Метод для сохранения фильтров в SharedPreferences
  Future<void> saveToPreferences() async {
    await AppPreferences.setValue('product_filter_options', toJson());
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      if (_priorityLevel != null) 'priority_level': _priorityLevel,
      if (_warehouseId != null) 'warehouse_id': _warehouseId,
      if (_groupId != null) 'group_id': _groupId,
    };
  }

  // Проверка, пустой ли фильтр
  bool get isEmpty =>
      _priorityLevel == null && _warehouseId == null && _groupId == null;

  // Приватный метод для автоматического сохранения изменений
  void _saveToPreferences() {
    AppPreferences.setValue('product_filter_options', toJson());
  }

  void reset() {
    _priorityLevel = null; // Значение по умолчанию
    _warehouseId = null; // Значение по умолчанию
    _groupId = null; // Значение по умолчанию
    _saveToPreferences(); // Сохраняем изменения
  }
}
