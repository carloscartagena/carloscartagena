import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/comment.dart';
import '../models/post.dart';

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
    final path = join(dbPath, 'social_app.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        avatar_color TEXT NOT NULL,
        caption TEXT NOT NULL,
        image_emoji TEXT NOT NULL,
        bg_color TEXT NOT NULL,
        likes INTEGER NOT NULL,
        liked_by_me INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        username TEXT NOT NULL,
        text TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final now = DateTime.now();
    final posts = [
      Post(username: 'viajero_bo', avatarColor: 'FFE1306C', caption: 'Atardecer en el Salar de Uyuni 🌅', imageEmoji: '🏞️', bgColor: 'FFFFE0B2', likes: 128, timestamp: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch),
      Post(username: 'foodie_lpz', avatarColor: 'FF833AB4', caption: 'Salteñas recien horneadas 😋', imageEmoji: '🥟', bgColor: 'FFFFCDD2', likes: 86, timestamp: now.subtract(const Duration(hours: 5)).millisecondsSinceEpoch),
      Post(username: 'devlife', avatarColor: 'FF405DE6', caption: 'Terminando mi app en Flutter 💙', imageEmoji: '💻', bgColor: 'FFBBDEFB', likes: 254, timestamp: now.subtract(const Duration(hours: 8)).millisecondsSinceEpoch),
    ];
    for (final p in posts) {
      final id = await db.insert('posts', p.toMap());
      await db.insert('comments', Comment(postId: id, username: 'ana_q', text: 'Que genial! 🔥', timestamp: now.millisecondsSinceEpoch).toMap());
    }
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final rows = await db.query('posts', orderBy: 'timestamp DESC');
    return rows.map(Post.fromMap).toList();
  }

  Future<int> insertPost(Post post) async {
    final db = await database;
    return db.insert('posts', post.toMap());
  }

  Future<void> updateLike(Post post) async {
    final db = await database;
    await db.update(
      'posts',
      {'likes': post.likes, 'liked_by_me': post.likedByMe ? 1 : 0},
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  Future<List<Comment>> getComments(int postId) async {
    final db = await database;
    final rows = await db.query('comments',
        where: 'post_id = ?', whereArgs: [postId], orderBy: 'timestamp ASC');
    return rows.map(Comment.fromMap).toList();
  }

  Future<int> getCommentCount(int postId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) AS c FROM comments WHERE post_id = ?', [postId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> insertComment(Comment comment) async {
    final db = await database;
    return db.insert('comments', comment.toMap());
  }
}
