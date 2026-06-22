import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi carrito')),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Tu carrito esta vacio'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      child: ListTile(
                        leading: Text(item.product.emoji, style: const TextStyle(fontSize: 28)),
                        title: Text(item.product.name),
                        subtitle: Text('Bs ${item.product.price.toStringAsFixed(0)} c/u'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => cart.remove(item.product),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => cart.add(item.product, cart.restaurantName ?? ''),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _summary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _summary(BuildContext context, CartProvider cart) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 18)),
                Text('Bs ${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Confirmar pedido'),
                onPressed: () async {
                  final order = await cart.checkout();
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pedido confirmado 🎉'),
                      content: Text(
                          'Pedido #${order.id} de ${order.restaurantName}\nTotal: Bs ${order.total.toStringAsFixed(2)}'),
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
    );
  }
}
