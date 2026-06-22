class Restaurant {
  final int? id;
  final String name;
  final String category;
  final double rating;
  final int deliveryMinutes;
  final double deliveryFee;
  final String emoji;

  Restaurant({
    this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryMinutes,
    required this.deliveryFee,
    this.emoji = '🍽️',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'rating': rating,
        'delivery_minutes': deliveryMinutes,
        'delivery_fee': deliveryFee,
        'emoji': emoji,
      };

  factory Restaurant.fromMap(Map<String, dynamic> m) => Restaurant(
        id: m['id'] as int?,
        name: m['name'] as String,
        category: m['category'] as String,
        rating: (m['rating'] as num).toDouble(),
        deliveryMinutes: m['delivery_minutes'] as int,
        deliveryFee: (m['delivery_fee'] as num).toDouble(),
        emoji: m['emoji'] as String? ?? '🍽️',
      );
}
