import 'package:tabakroom_staff/models/bonus_transactions.dart';
import 'package:tabakroom_staff/models/counterparty.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';

class DetectSuspiciousBonus {
  final int id;
  final Counterparty user;
  final DateTime detectedAt;
  final bool isResolved;
  final int? reviewedBy; // Может быть null
  final DateTime? resolvedAt; // Может быть null
  final List<BonusTransaction> transactions;

  DetectSuspiciousBonus({
    required this.id,
    required this.user,
    required this.detectedAt,
    required this.isResolved,
    this.reviewedBy,
    this.resolvedAt,
    required this.transactions,
  });

  // Фабрика для создания объекта из JSON
  factory DetectSuspiciousBonus.fromJson(Map<String, dynamic> json) {
    return DetectSuspiciousBonus(
      id: json['id'],
      user: Counterparty.fromJson(json['user']),
      detectedAt: DateTime.parse(json['detected_at']),
      isResolved: json['is_resolved'],
      reviewedBy: json['reviewed_by'],
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'])
          : null,
      transactions: (json['transactions'] as List)
          .map((txn) => BonusTransaction.fromJson(txn))
          .toList(),
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'detected_at': detectedAt.toIso8601String(),
      'is_resolved': isResolved,
      'reviewed_by': reviewedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'transactions': transactions.map((txn) => txn.toJson()).toList(),
    };
  }
}

class FilterOptions {
  bool? _isResolved; // Закрытое поле для флага "Проверено ли"

  // Геттер для доступа к значению
  bool? get isResolved => _isResolved;

  // Сеттер с автоматическим сохранением
  set isResolved(bool? value) {
    _isResolved = value;
    _saveToPreferences();
  }

  // Конструктор
  FilterOptions({
    bool? isResolved,
  }) : _isResolved = isResolved;

  // Конструктор из JSON
  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      isResolved: json['is_resolved'],
    );
  }

  // Асинхронный фабричный конструктор для загрузки данных из SharedPreferences
  static Future<FilterOptions> loadFromPreferences() async {
    final json = await AppPreferences.getValue<Map<String, dynamic>>(
        'transactions_filter_options');
    if (json != null) {
      return FilterOptions.fromJson(json);
    }
    return FilterOptions(); // Возвращаем объект с дефолтными значениями
  }

  // Метод для сохранения фильтров в SharedPreferences
  Future<void> saveToPreferences() async {
    await AppPreferences.setValue('transactions_filter_options', toJson());
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      if (_isResolved != null) 'is_resolved': _isResolved,
    };
  }

  // Проверка, пустой ли фильтр
  bool get isEmpty => _isResolved == null;

  // Приватный метод для автоматического сохранения изменений
  Future<void> _saveToPreferences() async {
    await AppPreferences.setValue('transactions_filter_options', toJson());
  }

  // Метод для обновления значений
  void update({bool? isResolved}) {
    if (isResolved != null) this.isResolved = isResolved;
  }

  // Метод для сброса значений
  void reset() {
    _isResolved = null;
    _saveToPreferences();
  }
}
