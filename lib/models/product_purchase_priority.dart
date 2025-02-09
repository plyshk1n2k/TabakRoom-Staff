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
  final String sectionApp; // Описание раздела приложения

  List<String>? _priorityLevel; // Теперь список
  List<int>? _warehouseId; // Теперь список
  List<int>? _groupId; // Теперь список

  // Геттеры
  List<String>? get priorityLevel => _priorityLevel;
  List<int>? get warehouseId => _warehouseId;
  List<int>? get groupId => _groupId;

  // Сеттеры с автоматическим сохранением
  set priorityLevel(List<String>? value) {
    _priorityLevel = value;
    _saveToPreferences();
  }

  set warehouseId(List<int>? value) {
    _warehouseId = value;
    _saveToPreferences();
  }

  set groupId(List<int>? value) {
    _groupId = value;
    _saveToPreferences();
  }

  // Конструктор
  FilterOptions({
    required this.sectionApp,
    List<String>? priorityLevel,
    List<int>? warehouseId,
    List<int>? groupId,
  })  : _priorityLevel = priorityLevel ?? [],
        _warehouseId = warehouseId ?? [],
        _groupId = groupId ?? [];

  // Конструктор из JSON
  factory FilterOptions.fromJson(String sectionApp, Map<String, dynamic> json) {
    return FilterOptions(
      sectionApp: sectionApp,
      priorityLevel: json['priority_level'] != null
          ? List<String>.from(json['priority_level'])
          : [],
      warehouseId: json['warehouse_id'] != null
          ? List<int>.from(json['warehouse_id'])
          : [],
      groupId: json['group_id'] != null ? List<int>.from(json['group_id']) : [],
    );
  }

  // Загрузка данных из SharedPreferences
  static Future<FilterOptions> loadFromPreferences(String sectionApp) async {
    final key = 'filter_options_$sectionApp';
    final json = await AppPreferences.getValue<Map<String, dynamic>>(key);
    if (json != null) {
      return FilterOptions.fromJson(sectionApp, json);
    }
    return FilterOptions(sectionApp: sectionApp);
  }

  // Сохранение фильтров в SharedPreferences
  Future<void> saveToPreferences() async {
    final key = 'filter_options_$sectionApp';
    await AppPreferences.setValue(key, toJson());
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'priority_level': _priorityLevel ?? [],
      'warehouse_id': _warehouseId ?? [],
      'group_id': _groupId ?? [],
    };
  }

  // Проверка, пустой ли фильтр
  bool get isEmpty =>
      (_priorityLevel == null || _priorityLevel!.isEmpty) &&
      (_warehouseId == null || _warehouseId!.isEmpty) &&
      (_groupId == null || _groupId!.isEmpty);

  // Автоматическое сохранение изменений
  Future<void> _saveToPreferences() async {
    await saveToPreferences();
  }

  // Сброс фильтров
  void reset() {
    _priorityLevel = [];
    _warehouseId = [];
    _groupId = [];
    _saveToPreferences();
  }
}
