import 'package:flutter/foundation.dart';

import '../db/database_helper.dart';
import '../models/contact.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Contact> _contacts = [];
  final Map<int, Message?> _lastMessages = {};
  List<Message> _currentMessages = [];

  List<Contact> get contacts => _contacts;
  List<Message> get currentMessages => _currentMessages;

  Message? lastMessageFor(int contactId) => _lastMessages[contactId];

  Future<void> loadContacts() async {
    _contacts = await _db.getContacts();
    for (final c in _contacts) {
      if (c.id != null) {
        _lastMessages[c.id!] = await _db.getLastMessage(c.id!);
      }
    }
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _db.insertContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _db.deleteContact(id);
    await loadContacts();
  }

  Future<void> loadMessages(int contactId) async {
    _currentMessages = await _db.getMessages(contactId);
    notifyListeners();
  }

  Future<void> sendMessage(int contactId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final msg = Message(
      contactId: contactId,
      text: trimmed,
      isMe: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.insertMessage(msg);
    await loadMessages(contactId);
    _lastMessages[contactId] = await _db.getLastMessage(contactId);

    // Simulate an auto-reply so the chat feels alive.
    final reply = Message(
      contactId: contactId,
      text: _autoReply(trimmed),
      isMe: false,
      timestamp: DateTime.now().add(const Duration(seconds: 1)).millisecondsSinceEpoch,
    );
    await _db.insertMessage(reply);
    await loadMessages(contactId);
    _lastMessages[contactId] = await _db.getLastMessage(contactId);
    notifyListeners();
  }

  String _autoReply(String text) {
    final t = text.toLowerCase();
    if (t.contains('hola')) return 'Hola! Como estas?';
    if (t.contains('?')) return 'Buena pregunta, dejame revisar.';
    return 'Mensaje recibido 👍';
  }
}
