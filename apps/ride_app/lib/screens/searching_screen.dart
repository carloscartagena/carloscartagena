import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver.dart';
import '../providers/ride_provider.dart';
import 'trip_active_screen.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    final provider = context.read<RideProvider>();
    await Future.delayed(const Duration(seconds: 2));
    final Driver? driver = await provider.findDriver();
    if (!mounted) return;
    if (driver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay conductores disponibles')),
      );
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TripActiveScreen(driver: driver)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text('Buscando conductor cercano...',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
