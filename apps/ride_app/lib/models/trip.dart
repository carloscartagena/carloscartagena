class Trip {
  final int? id;
  final String origin;
  final String destination;
  final String driverName;
  final String carModel;
  final double distanceKm;
  final double fare;
  final int timestamp;
  final String status; // completado, cancelado

  Trip({
    this.id,
    required this.origin,
    required this.destination,
    required this.driverName,
    required this.carModel,
    required this.distanceKm,
    required this.fare,
    required this.timestamp,
    this.status = 'completado',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'origin': origin,
        'destination': destination,
        'driver_name': driverName,
        'car_model': carModel,
        'distance_km': distanceKm,
        'fare': fare,
        'timestamp': timestamp,
        'status': status,
      };

  factory Trip.fromMap(Map<String, dynamic> m) => Trip(
        id: m['id'] as int?,
        origin: m['origin'] as String,
        destination: m['destination'] as String,
        driverName: m['driver_name'] as String,
        carModel: m['car_model'] as String,
        distanceKm: (m['distance_km'] as num).toDouble(),
        fare: (m['fare'] as num).toDouble(),
        timestamp: m['timestamp'] as int,
        status: m['status'] as String? ?? 'completado',
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
