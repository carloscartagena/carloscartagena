import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/driver.dart';
import '../models/trip.dart';

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
    final path = join(dbPath, 'ride_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE drivers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        car_model TEXT NOT NULL,
        plate TEXT NOT NULL,
        rating REAL NOT NULL,
        vehicle_type TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        driver_name TEXT NOT NULL,
        car_model TEXT NOT NULL,
        distance_km REAL NOT NULL,
        fare REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final drivers = [
      Driver(name: 'Carlos Mamani', carModel: 'Toyota Corolla', plate: '1234-ABC', rating: 4.9, vehicleType: 'economy'),
      Driver(name: 'Ana Quispe', carModel: 'Nissan Versa', plate: '5678-DEF', rating: 4.8, vehicleType: 'economy'),
      Driver(name: 'Luis Flores', carModel: 'Hyundai Tucson', plate: '9012-GHI', rating: 4.7, vehicleType: 'comfort'),
      Driver(name: 'Marta Choque', carModel: 'Toyota Hiace', plate: '3456-JKL', rating: 4.6, vehicleType: 'xl'),
    ];
    for (final d in drivers) {
      await db.insert('drivers', d.toMap());
    }
  }

  Future<List<Driver>> getDriversByType(String vehicleType) async {
    final db = await database;
    final rows = await db.query('drivers',
        where: 'vehicle_type = ?', whereArgs: [vehicleType], orderBy: 'rating DESC');
    return rows.map(Driver.fromMap).toList();
  }

  Future<int> insertTrip(Trip trip) async {
    final db = await database;
    return db.insert('trips', trip.toMap());
  }

  Future<List<Trip>> getTrips() async {
    final db = await database;
    final rows = await db.query('trips', orderBy: 'timestamp DESC');
    return rows.map(Trip.fromMap).toList();
  }
}
