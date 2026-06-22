class Message {
  final int? id;
  final int chatId;
  final String sender;
  final String text;
  final bool isMe;
  final int timestamp;

  Message({
    this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'chat_id': chatId,
        'sender': sender,
        'text': text,
        'is_me': isMe ? 1 : 0,
        'timestamp': timestamp,
      };

  factory Message.fromMap(Map<String, dynamic> m) => Message(
        id: m['id'] as int?,
        chatId: m['chat_id'] as int,
        sender: m['sender'] as String,
        text: m['text'] as String,
        isMe: (m['is_me'] as int) == 1,
        timestamp: m['timestamp'] as int,
      );

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
