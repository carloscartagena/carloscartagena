enum ChatType { private, group, channel }

ChatType chatTypeFromString(String s) {
  switch (s) {
    case 'group':
      return ChatType.group;
    case 'channel':
      return ChatType.channel;
    default:
      return ChatType.private;
  }
}

String chatTypeToString(ChatType t) => t.name;

class Chat {
  final int? id;
  final String name;
  final ChatType type;
  final int members; // 0 for private
  final String avatarColor;
  final bool muted;

  Chat({
    this.id,
    required this.name,
    required this.type,
    this.members = 0,
    this.avatarColor = 'FF229ED9',
    this.muted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': chatTypeToString(type),
        'members': members,
        'avatar_color': avatarColor,
        'muted': muted ? 1 : 0,
      };

  factory Chat.fromMap(Map<String, dynamic> m) => Chat(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: chatTypeFromString(m['type'] as String),
        members: m['members'] as int? ?? 0,
        avatarColor: m['avatar_color'] as String? ?? 'FF229ED9',
        muted: (m['muted'] as int? ?? 0) == 1,
      );

  String get initials {
    final parts = name.trim().replaceAll(RegExp(r'[^\w\s]'), '').split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '#';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String get subtitleLabel {
    switch (type) {
      case ChatType.group:
        return '$members miembros';
      case ChatType.channel:
        return '$members suscriptores';
      case ChatType.private:
        return 'en linea';
    }
  }
}
