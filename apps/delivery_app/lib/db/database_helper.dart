import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order.dart';
import '../models/product.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'delivery_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        rating REAL NOT NULL,
        delivery_minutes INTEGER NOT NULL,
        delivery_fee REAL NOT NULL,
        emoji TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        emoji TEXT NOT NULL,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_name TEXT NOT NULL,
        total REAL NOT NULL,
        item_count INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final restaurants = [
      Restaurant(name: 'Burger House', category: 'Hamburguesas', rating: 4.6, deliveryMinutes: 25, deliveryFee: 8, emoji: '🍔'),
      Restaurant(name: 'Pizza Napoli', category: 'Pizzas', rating: 4.8, deliveryMinutes: 35, deliveryFee: 10, emoji: '🍕'),
      Restaurant(name: 'Sushi Zen', category: 'Japonesa', rating: 4.7, deliveryMinutes: 40, deliveryFee: 12, emoji: '🍣'),
      Restaurant(name: 'Cafe Central', category: 'Cafeteria', rating: 4.5, deliveryMinutes: 20, deliveryFee: 6, emoji: '☕'),
    ];

    final menus = <List<Product>>[
      [
        Product(restaurantId: 1, name: 'Clasica', description: 'Carne, queso, lechuga', price: 28, emoji: '🍔'),
        Product(restaurantId: 1, name: 'Doble Bacon', description: 'Doble carne y tocino', price: 42, emoji: '🥓'),
        Product(restaurantId: 1, name: 'Papas Fritas', description: 'Porcion grande', price: 15, emoji: '🍟'),
      ],
      [
        Product(restaurantId: 2, name: 'Margarita', description: 'Tomate y albahaca', price: 55, emoji: '🍕'),
        Product(restaurantId: 2, name: 'Pepperoni', description: 'Doble pepperoni', price: 65, emoji: '🍕'),
        Product(restaurantId: 2, name: 'Gaseosa 2L', description: 'Bebida fria', price: 18, emoji: '🥤'),
      ],
      [
        Product(restaurantId: 3, name: 'Roll California', description: '8 piezas', price: 48, emoji: '🍣'),
        Product(restaurantId: 3, name: 'Ramen', description: 'Caldo de cerdo', price: 52, emoji: '🍜'),
      ],
      [
        Product(restaurantId: 4, name: 'Capuchino', description: 'Espresso con leche', price: 16, emoji: '☕'),
        Product(restaurantId: 4, name: 'Cheesecake', description: 'Porcion individual', price: 22, emoji: '🍰'),
      ],
    ];

    for (var i = 0; i < restaurants.length; i++) {
      final id = await db.insert('restaurants', restaurants[i].toMap());
      for (final p in menus[i]) {
        final map = p.toMap();
        map['restaurant_id'] = id;
        map.remove('id');
        await db.insert('products', map);
      }
    }
  }

  Future<List<Restaurant>> getRestaurants() async {
    final db = await database;
    final rows = await db.query('restaurants', orderBy: 'rating DESC');
    return rows.map(Restaurant.fromMap).toList();
  }

  Future<List<Product>> getProducts(int restaurantId) async {
    final db = await database;
    final rows = await db.query('products', where: 'restaurant_id = ?', whereArgs: [restaurantId]);
    return rows.map(Product.fromMap).toList();
  }

  Future<int> insertOrder(FoodOrder order) async {
    final db = await database;
    return db.insert('orders', order.toMap());
  }

  Future<List<FoodOrder>> getOrders() async {
    final db = await database;
    final rows = await db.query('orders', orderBy: 'timestamp DESC');
    return rows.map(FoodOrder.fromMap).toList();
  }
}
