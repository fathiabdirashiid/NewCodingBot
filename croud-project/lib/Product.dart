class Product {
  String id;
  String name;
  String? description;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'],
        name: json['name'],
        description: json['description'] ?? "",
        price: json['price'],
        stock: json['stock'],
      );
}
