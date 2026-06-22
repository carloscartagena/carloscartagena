import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<FoodOrder>> _future;

  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.instance.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos')),
      body: FutureBuilder<List<FoodOrder>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('Aun no tienes pedidos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.fastfood)),
                  title: Text(o.restaurantName),
                  subtitle: Text(
                      '${o.itemCount} items  •  ${DateFormat('dd/MM HH:mm').format(o.dateTime)}\n${o.status}'),
                  isThreeLine: true,
                  trailing: Text('Bs ${o.total.toStringAsFixed(0)}',
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
