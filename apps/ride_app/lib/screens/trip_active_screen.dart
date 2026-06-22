import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../providers/ride_provider.dart';

class TripActiveScreen extends StatelessWidget {
  final Driver driver;
  const TripActiveScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RideProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Viaje en curso')),
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.green.shade50,
            child: const Center(
              child: Icon(Icons.navigation, size: 64, color: Colors.green),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      child: Text(driver.name.substring(0, 1)),
                    ),
                    title: Text(driver.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${driver.carModel}  •  ${driver.plate}'),
                    trailing: Text('⭐ ${driver.rating}'),
                  ),
                  const Divider(),
                  _row(Icons.my_location, 'Origen', provider.origin),
                  _row(Icons.location_on, 'Destino', provider.destination),
                  _row(Icons.route, 'Distancia', '${provider.distanceKm} km'),
                  _row(Icons.attach_money, 'Tarifa',
                      'Bs ${provider.estimatedFare.toStringAsFixed(2)}'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.flag),
                      label: const Text('Finalizar viaje'),
                      onPressed: () async {
                        final trip = await provider.confirmTrip(driver);
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Viaje finalizado ✅'),
                            content: Text(
                                'Gracias por viajar con ${trip.driverName}.\nTotal: Bs ${trip.fare.toStringAsFixed(2)}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
