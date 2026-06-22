import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ride_option.dart';
import '../providers/ride_provider.dart';
import 'searching_screen.dart';
import 'trips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _originCtrl = TextEditingController(text: 'Mi ubicacion actual');
  final _destCtrl = TextEditingController();

  @override
  void dispose() {
    _originCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RideProvider>();
    final hasRoute = provider.distanceKm > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RideGo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TripsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fake map placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, size: 56, color: Colors.green),
                    Text('Mapa (simulado)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _originCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.my_location, color: Colors.green),
                labelText: 'Origen',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: Colors.red),
                labelText: 'Destino',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Calcular ruta'),
                onPressed: () {
                  if (_destCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingresa un destino')),
                    );
                    return;
                  }
                  context
                      .read<RideProvider>()
                      .setRoute(_originCtrl.text.trim(), _destCtrl.text.trim());
                },
              ),
            ),
            if (hasRoute) ...[
              const SizedBox(height: 20),
              Text('Distancia estimada: ${provider.distanceKm} km',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...RideOption.all.map((opt) => _optionTile(context, provider, opt)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchingScreen()),
                  ),
                  child: Text(
                      'Solicitar ${provider.selectedOption.label}  •  Bs ${provider.estimatedFare.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _optionTile(BuildContext context, RideProvider provider, RideOption opt) {
    final selected = provider.selectedOption.type == opt.type;
    return Card(
      color: selected ? Colors.green.shade50 : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: selected ? Colors.green : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(opt.icon, size: 32),
        title: Text(opt.label),
        subtitle: Text('${opt.capacity} personas  •  ${provider.estimatedMinutes} min'),
        trailing: Text('Bs ${opt.fareFor(provider.distanceKm).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        onTap: () => provider.selectOption(opt),
      ),
    );
  }
}
