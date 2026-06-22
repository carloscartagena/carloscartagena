class Comment {
  final int? id;
  final int postId;
  final String username;
  final String text;
  final int timestamp;

  Comment({
    this.id,
    required this.postId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'post_id': postId,
        'username': username,
        'text': text,
        'timestamp': timestamp,
      };

  factory Comment.fromMap(Map<String, dynamic> m) => Comment(
        id: m['id'] as int?,
        postId: m['post_id'] as int,
        username: m['username'] as String,
        text: m['text'] as String,
        timestamp: m['timestamp'] as int,
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
