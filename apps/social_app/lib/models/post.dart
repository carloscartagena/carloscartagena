class Post {
  final int? id;
  final String username;
  final String avatarColor;
  final String caption;
  final String imageEmoji; // emoji used as the "photo" placeholder
  final String bgColor; // background color of the photo area
  int likes;
  bool likedByMe;
  final int timestamp;

  Post({
    this.id,
    required this.username,
    required this.avatarColor,
    required this.caption,
    required this.imageEmoji,
    required this.bgColor,
    this.likes = 0,
    this.likedByMe = false,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'avatar_color': avatarColor,
        'caption': caption,
        'image_emoji': imageEmoji,
        'bg_color': bgColor,
        'likes': likes,
        'liked_by_me': likedByMe ? 1 : 0,
        'timestamp': timestamp,
      };

  factory Post.fromMap(Map<String, dynamic> m) => Post(
        id: m['id'] as int?,
        username: m['username'] as String,
        avatarColor: m['avatar_color'] as String,
        caption: m['caption'] as String,
        imageEmoji: m['image_emoji'] as String,
        bgColor: m['bg_color'] as String,
        likes: m['likes'] as int? ?? 0,
        likedByMe: (m['liked_by_me'] as int? ?? 0) == 1,
        timestamp: m['timestamp'] as int,
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
