class Counterparty {
  final int? id;
  final String name;

  Counterparty({this.id, required this.name});

  factory Counterparty.fromJson(Map<String, dynamic> json) {
    return Counterparty(
      id: json['id'],
      name: json['name'] ?? 'Неизвестный контрагент',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
