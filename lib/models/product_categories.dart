class ProductCategories {
  final int id;
  final String name;

  ProductCategories({required this.id, required this.name});

  factory ProductCategories.fromJson(Map<String, dynamic> json) {
    return ProductCategories(
      id: json['id'],
      name: json['name'] ?? 'Неизвестная группа',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
