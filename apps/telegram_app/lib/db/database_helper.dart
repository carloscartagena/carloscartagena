import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chat.dart';
import '../models/message.dart';

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
    final path = join(dbPath, 'telegram_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        members INTEGER NOT NULL,
        avatar_color TEXT NOT NULL,
        muted INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chat_id INTEGER NOT NULL,
        sender TEXT NOT NULL,
        text TEXT NOT NULL,
        is_me INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (chat_id) REFERENCES chats (id) ON DELETE CASCADE
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final now = DateTime.now();
    final chats = [
      Chat(name: 'Sofia Vargas', type: ChatType.private, avatarColor: 'FF229ED9'),
      Chat(name: 'Equipo Flutter', type: ChatType.group, members: 12, avatarColor: 'FF1B873F'),
      Chat(name: 'Noticias Tech', type: ChatType.channel, members: 3450, avatarColor: 'FFB3261E'),
      Chat(name: 'Familia ❤️', type: ChatType.group, members: 6, avatarColor: 'FF7D5260'),
    ];
    for (final c in chats) {
      final id = await db.insert('chats', c.toMap());
      await db.insert('messages', Message(
        chatId: id,
        sender: c.type == ChatType.private ? c.name : 'Admin',
        text: c.type == ChatType.channel
            ? 'Bienvenido al canal ${c.name}.'
            : 'Hola! Este es el chat de ${c.name}.',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 20)).millisecondsSinceEpoch,
      ).toMap());
    }
  }

  Future<List<Chat>> getChats({ChatType? type}) async {
    final db = await database;
    final rows = type == null
        ? await db.query('chats', orderBy: 'id ASC')
        : await db.query('chats',
            where: 'type = ?', whereArgs: [chatTypeToString(type)], orderBy: 'id ASC');
    return rows.map(Chat.fromMap).toList();
  }

  Future<int> insertChat(Chat chat) async {
    final db = await database;
    return db.insert('chats', chat.toMap());
  }

  Future<Message?> getLastMessage(int chatId) async {
    final db = await database;
    final rows = await db.query('messages',
        where: 'chat_id = ?', whereArgs: [chatId], orderBy: 'timestamp DESC', limit: 1);
    if (rows.isEmpty) return null;
    return Message.fromMap(rows.first);
  }

  Future<List<Message>> getMessages(int chatId) async {
    final db = await database;
    final rows = await db.query('messages',
        where: 'chat_id = ?', whereArgs: [chatId], orderBy: 'timestamp ASC');
    return rows.map(Message.fromMap).toList();
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert('messages', message.toMap());
  }
}
