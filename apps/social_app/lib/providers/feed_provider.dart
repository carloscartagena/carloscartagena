import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/comment.dart';
import '../models/post.dart';

class FeedProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Post> _posts = [];
  final Map<int, int> _commentCounts = {};

  List<Post> get posts => _posts;
  int commentCountFor(int postId) => _commentCounts[postId] ?? 0;

  String get currentUser => 'mi_usuario';

  Future<void> loadPosts() async {
    _posts = await _db.getPosts();
    for (final p in _posts) {
      if (p.id != null) {
        _commentCounts[p.id!] = await _db.getCommentCount(p.id!);
      }
    }
    notifyListeners();
  }

  Future<void> toggleLike(Post post) async {
    if (post.likedByMe) {
      post.likes -= 1;
      post.likedByMe = false;
    } else {
      post.likes += 1;
      post.likedByMe = true;
    }
    await _db.updateLike(post);
    notifyListeners();
  }

  Future<void> createPost(String caption, String emoji, String bgColor) async {
    final post = Post(
      username: currentUser,
      avatarColor: 'FF405DE6',
      caption: caption,
      imageEmoji: emoji,
      bgColor: bgColor,
      likes: 0,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.insertPost(post);
    await loadPosts();
  }

  Future<List<Comment>> getComments(int postId) => _db.getComments(postId);

  Future<void> addComment(int postId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _db.insertComment(Comment(
      postId: postId,
      username: currentUser,
      text: trimmed,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    _commentCounts[postId] = await _db.getCommentCount(postId);
    notifyListeners();
  }
}
