import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';
import '../models/message.dart';

/// Singleton helper that manages the SQLite database for the chat app.
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
    final path = join(dbPath, 'chat_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        avatar_color TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_me INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
      )
    ''');

    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final now = DateTime.now();
    final demoContacts = [
      Contact(name: 'Maria Lopez', phone: '+591 700 11111', avatarColor: 'FF6750A4', status: 'En linea'),
      Contact(name: 'Juan Perez', phone: '+591 700 22222', avatarColor: 'FF1B873F', status: 'Ocupado'),
      Contact(name: 'Grupo Familia', phone: '+591 700 33333', avatarColor: 'FFB3261E', status: '4 participantes'),
    ];

    for (final c in demoContacts) {
      final id = await db.insert('contacts', c.toMap());
      await db.insert('messages', Message(
        contactId: id,
        text: 'Hola ${c.name.split(' ').first}! Bienvenido a la app de chat.',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
      ).toMap());
      await db.insert('messages', Message(
        contactId: id,
        text: 'Gracias! Probando la base de datos local.',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 28)).millisecondsSinceEpoch,
      ).toMap());
    }
  }

  // ---------- Contacts ----------
  Future<List<Contact>> getContacts() async {
    final db = await database;
    final rows = await db.query('contacts', orderBy: 'name ASC');
    return rows.map(Contact.fromMap).toList();
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return db.insert('contacts', contact.toMap());
  }

  Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete('messages', where: 'contact_id = ?', whereArgs: [id]);
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Messages ----------
  Future<List<Message>> getMessages(int contactId) async {
    final db = await database;
    final rows = await db.query(
      'messages',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'timestamp ASC',
    );
    return rows.map(Message.fromMap).toList();
  }

  Future<Message?> getLastMessage(int contactId) async {
    final db = await database;
    final rows = await db.query(
      'messages',
      where: 'contact_id = ?',
      whereArgs: [contactId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Message.fromMap(rows.first);
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert('messages', message.toMap());
  }
}
