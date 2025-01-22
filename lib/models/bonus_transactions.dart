class BonusTransaction {
  final int id;
  final String name;
  final int bonusValue;
  final String transactionType;
  final String transactionStatus;
  final DateTime executionDate;

  BonusTransaction({
    required this.id,
    required this.name,
    required this.bonusValue,
    required this.transactionType,
    required this.transactionStatus,
    required this.executionDate,
  });

  // Фабрика для создания объекта из JSON
  factory BonusTransaction.fromJson(Map<String, dynamic> json) {
    return BonusTransaction(
      id: json['id'],
      name: json['name'],
      bonusValue: json['bonus_value'],
      transactionType: json['transaction_type'],
      transactionStatus: json['transaction_status'],
      executionDate: DateTime.parse(json['execution_date']),
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bonus_value': bonusValue,
      'transaction_type': transactionType,
      'transaction_status': transactionStatus,
      'execution_date': executionDate.toIso8601String(),
    };
  }
}
