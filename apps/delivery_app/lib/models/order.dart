class FoodOrder {
  final int? id;
  final String restaurantName;
  final double total;
  final int itemCount;
  final int timestamp;
  final String status;

  FoodOrder({
    this.id,
    required this.restaurantName,
    required this.total,
    required this.itemCount,
    required this.timestamp,
    this.status = 'En preparacion',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'restaurant_name': restaurantName,
        'total': total,
        'item_count': itemCount,
        'timestamp': timestamp,
        'status': status,
      };

  factory FoodOrder.fromMap(Map<String, dynamic> m) => FoodOrder(
        id: m['id'] as int?,
        restaurantName: m['restaurant_name'] as String,
        total: (m['total'] as num).toDouble(),
        itemCount: m['item_count'] as int,
        timestamp: m['timestamp'] as int,
        status: m['status'] as String? ?? 'En preparacion',
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
