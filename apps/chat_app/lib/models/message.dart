class Message {
  final int? id;
  final int contactId;
  final String text;
  final bool isMe; // true if sent by the current user
  final int timestamp; // millisecondsSinceEpoch

  Message({
    this.id,
    required this.contactId,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contact_id': contactId,
      'text': text,
      'is_me': isMe ? 1 : 0,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int?,
      contactId: map['contact_id'] as int,
      text: map['text'] as String,
      isMe: (map['is_me'] as int) == 1,
      timestamp: map['timestamp'] as int,
    );
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
