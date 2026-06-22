import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../providers/ride_provider.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de viajes')),
      body: FutureBuilder<List<Trip>>(
        future: context.read<RideProvider>().getTrips(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final trips = snapshot.data!;
          if (trips.isEmpty) {
            return const Center(child: Text('Aun no tienes viajes'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final t = trips[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.directions_car)),
                  title: Text('${t.origin}  →  ${t.destination}'),
                  subtitle: Text(
                      '${t.driverName}  •  ${t.distanceKm} km\n${DateFormat('dd/MM/yyyy HH:mm').format(t.dateTime)}'),
                  isThreeLine: true,
                  trailing: Text('Bs ${t.fare.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
