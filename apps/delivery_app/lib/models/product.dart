class Product {
  final int? id;
  final int restaurantId;
  final String name;
  final String description;
  final double price;
  final String emoji;

  Product({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    this.emoji = '🍔',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'restaurant_id': restaurantId,
        'name': name,
        'description': description,
        'price': price,
        'emoji': emoji,
      };

  factory Product.fromMap(Map<String, dynamic> m) => Product(
        id: m['id'] as int?,
        restaurantId: m['restaurant_id'] as int,
        name: m['name'] as String,
        description: m['description'] as String? ?? '',
        price: (m['price'] as num).toDouble(),
        emoji: m['emoji'] as String? ?? '🍔',
      );
}
