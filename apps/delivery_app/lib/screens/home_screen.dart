import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/database_helper.dart';
import '../models/restaurant.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Restaurant>> _future;

  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.instance.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Ya!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Mis pedidos',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
                if (cart.count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.amber,
                      child: Text('${cart.count}',
                          style: const TextStyle(fontSize: 11, color: Colors.black)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final restaurants = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final r = restaurants[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.red.shade50,
                    child: Text(r.emoji, style: const TextStyle(fontSize: 26)),
                  ),
                  title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${r.category}  •  ⭐ ${r.rating}  •  ${r.deliveryMinutes} min  •  Bs ${r.deliveryFee.toStringAsFixed(0)} envio',
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
