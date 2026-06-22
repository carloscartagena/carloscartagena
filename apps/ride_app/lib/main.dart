import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/ride_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RideApp());
}

class RideApp extends StatelessWidget {
  const RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RideProvider(),
      child: MaterialApp(
        title: 'Ride App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1FA463),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
