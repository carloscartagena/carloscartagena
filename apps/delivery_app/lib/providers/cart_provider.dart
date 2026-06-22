import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/order.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem(this.product, {this.quantity = 1});
  double get subtotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final Map<int, CartItem> _items = {};
  String? _restaurantName;

  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (sum, i) => sum + i.quantity);
  double get total => _items.values.fold(0.0, (sum, i) => sum + i.subtotal);
  String? get restaurantName => _restaurantName;

  void add(Product product, String restaurantName) {
    _restaurantName = restaurantName;
    final id = product.id!;
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
    } else {
      _items[id] = CartItem(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    final id = product.id!;
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _restaurantName = null;
    notifyListeners();
  }

  Future<FoodOrder> checkout() async {
    final order = FoodOrder(
      restaurantName: _restaurantName ?? 'Pedido',
      total: total,
      itemCount: count,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      status: 'En preparacion',
    );
    final id = await _db.insertOrder(order);
    clear();
    return FoodOrder(
      id: id,
      restaurantName: order.restaurantName,
      total: order.total,
      itemCount: order.itemCount,
      timestamp: order.timestamp,
      status: order.status,
    );
  }
}
