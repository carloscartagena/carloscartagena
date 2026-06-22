import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/chat.dart';
import '../models/message.dart';

class TelegramProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Chat> _chats = [];
  final Map<int, Message?> _lastMessages = {};
  List<Message> _currentMessages = [];

  List<Chat> get chats => _chats;
  List<Message> get currentMessages => _currentMessages;
  Message? lastMessageFor(int chatId) => _lastMessages[chatId];

  List<Chat> chatsOfType(ChatType? type) =>
      type == null ? _chats : _chats.where((c) => c.type == type).toList();

  Future<void> loadChats() async {
    _chats = await _db.getChats();
    for (final c in _chats) {
      if (c.id != null) {
        _lastMessages[c.id!] = await _db.getLastMessage(c.id!);
      }
    }
    notifyListeners();
  }

  Future<void> addChat(Chat chat) async {
    await _db.insertChat(chat);
    await loadChats();
  }

  Future<void> loadMessages(int chatId) async {
    _currentMessages = await _db.getMessages(chatId);
    notifyListeners();
  }

  Future<void> sendMessage(Chat chat, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _db.insertMessage(Message(
      chatId: chat.id!,
      sender: 'Yo',
      text: trimmed,
      isMe: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    await loadMessages(chat.id!);
    _lastMessages[chat.id!] = await _db.getLastMessage(chat.id!);
    notifyListeners();
  }
}
