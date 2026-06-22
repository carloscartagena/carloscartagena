import 'package:flutter/material.dart';

class RideOption {
  final String type; // economy, comfort, xl
  final String label;
  final IconData icon;
  final double baseFare;
  final double perKm;
  final int capacity;

  const RideOption({
    required this.type,
    required this.label,
    required this.icon,
    required this.baseFare,
    required this.perKm,
    required this.capacity,
  });

  double fareFor(double distanceKm) => baseFare + perKm * distanceKm;

  static const List<RideOption> all = [
    RideOption(type: 'economy', label: 'Economy', icon: Icons.directions_car, baseFare: 8, perKm: 3.5, capacity: 4),
    RideOption(type: 'comfort', label: 'Comfort', icon: Icons.local_taxi, baseFare: 12, perKm: 5.0, capacity: 4),
    RideOption(type: 'xl', label: 'XL', icon: Icons.airport_shuttle, baseFare: 18, perKm: 6.5, capacity: 6),
  ];
}
