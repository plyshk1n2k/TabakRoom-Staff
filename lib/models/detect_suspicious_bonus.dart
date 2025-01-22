import 'package:tabakroom_staff/models/bonus_transactions.dart';
import 'package:tabakroom_staff/models/counterparty.dart';

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
  bool? isResolved; // Проверено ли
  FilterOptions({
    this.isResolved,
  });

  // 📦 Конструктор из JSON (например, для хранения в SharedPreferences)
  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      isResolved: json['is_resolved'],
    );
  }

  // 🔄 Преобразование в JSON (для отправки на сервер)
  Map<String, dynamic> toJson() {
    return {
      if (isResolved != null) 'is_resolved': isResolved,
    };
  }

  // ✅ Проверка, пустой ли фильтр
  bool get isEmpty => isResolved == null;

  // 🔄 Установка новых значений
  void update({bool? isResolved}) {
    if (isResolved != null) this.isResolved = isResolved;
  }
}
