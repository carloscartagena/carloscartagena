class Driver {
  final int? id;
  final String name;
  final String carModel;
  final String plate;
  final double rating;
  final String vehicleType; // economy, comfort, xl

  Driver({
    this.id,
    required this.name,
    required this.carModel,
    required this.plate,
    required this.rating,
    required this.vehicleType,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'car_model': carModel,
        'plate': plate,
        'rating': rating,
        'vehicle_type': vehicleType,
      };

  factory Driver.fromMap(Map<String, dynamic> m) => Driver(
        id: m['id'] as int?,
        name: m['name'] as String,
        carModel: m['car_model'] as String,
        plate: m['plate'] as String,
        rating: (m['rating'] as num).toDouble(),
        vehicleType: m['vehicle_type'] as String,
      );
}
