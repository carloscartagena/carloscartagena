import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../providers/telegram_provider.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool get _isChannel => widget.chat.type == ChatType.channel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelegramProvider>().loadMessages(widget.chat.id!).then((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _send() async {
    final text = _controller.text;
    _controller.clear();
    await context.read<TelegramProvider>().sendMessage(widget.chat, text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.chat;
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF0),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.name, style: const TextStyle(fontSize: 16)),
            Text(c.subtitleLabel, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TelegramProvider>(
              builder: (context, provider, _) {
                final messages = provider.currentMessages;
                if (messages.isEmpty) {
                  return const Center(child: Text('No hay mensajes'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => _bubble(messages[index], c.type),
                );
              },
            ),
          ),
          if (_isChannel)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: const Text('🔇 Solo los administradores pueden publicar',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            )
          else
            _composer(),
        ],
      ),
    );
  }

  Widget _bubble(Message m, ChatType type) {
    final showSender = type != ChatType.private && !m.isMe;
    return Align(
      alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: m.isMe ? const Color(0xFFEFFDDE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSender)
              Text(m.sender,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF229ED9), fontSize: 12)),
            Text(m.text, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 2),
            Text(DateFormat('HH:mm').format(m.dateTime),
                style: const TextStyle(fontSize: 10, color: Colors.black45)),
          ],
        ),
      ),
    );
  }

  Widget _composer() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF229ED9)),
              onPressed: _send,
            ),
          ],
        ),
      ),
    );
  }
}
