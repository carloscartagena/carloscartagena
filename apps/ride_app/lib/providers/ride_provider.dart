import 'dart:math';

import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/driver.dart';
import '../models/ride_option.dart';
import '../models/trip.dart';

class RideProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final Random _rng = Random();

  String origin = '';
  String destination = '';
  double distanceKm = 0;
  RideOption selectedOption = RideOption.all.first;

  void setRoute(String origin, String destination) {
    this.origin = origin;
    this.destination = destination;
    // Simulated distance based on text length so it is deterministic-ish.
    distanceKm = (3 + (origin.length + destination.length) % 12) +
        _rng.nextDouble() * 2;
    distanceKm = double.parse(distanceKm.toStringAsFixed(1));
    notifyListeners();
  }

  void selectOption(RideOption option) {
    selectedOption = option;
    notifyListeners();
  }

  double get estimatedFare => selectedOption.fareFor(distanceKm);
  int get estimatedMinutes => (distanceKm * 2.2).round() + 3;

  Future<Driver?> findDriver() async {
    final drivers = await _db.getDriversByType(selectedOption.type);
    if (drivers.isEmpty) return null;
    return drivers[_rng.nextInt(drivers.length)];
  }

  Future<Trip> confirmTrip(Driver driver) async {
    final trip = Trip(
      origin: origin,
      destination: destination,
      driverName: driver.name,
      carModel: driver.carModel,
      distanceKm: distanceKm,
      fare: double.parse(estimatedFare.toStringAsFixed(2)),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      status: 'completado',
    );
    final id = await _db.insertTrip(trip);
    return Trip(
      id: id,
      origin: trip.origin,
      destination: trip.destination,
      driverName: trip.driverName,
      carModel: trip.carModel,
      distanceKm: trip.distanceKm,
      fare: trip.fare,
      timestamp: trip.timestamp,
      status: trip.status,
    );
  }

  Future<List<Trip>> getTrips() => _db.getTrips();
}
