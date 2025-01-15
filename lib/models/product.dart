class Product {
  final int? id; // 🔄 Сделали id необязательным
  final String name;

  Product({this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], // Может быть null
      name: json['name'] ??
          'Неизвестный товар', // Подстраховка, если name отсутствует
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
