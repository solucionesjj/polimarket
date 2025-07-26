class Product {
  final int id;
  final String name;
  final String description;
  final int stock;
  final int supplierId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.supplierId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      stock: json['stock'] as int,
      supplierId: json['supplierId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stock': stock,
      'supplierId': supplierId,
    };
  }
}