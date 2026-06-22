import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../providers/telegram_provider.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _tabs = const [
    Tab(text: 'Todos'),
    Tab(text: 'Grupos'),
    Tab(text: 'Canales'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelegramProvider>().loadChats();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  IconData _iconFor(ChatType type) {
    switch (type) {
      case ChatType.group:
        return Icons.group;
      case ChatType.channel:
        return Icons.campaign;
      case ChatType.private:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram'),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Consumer<TelegramProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _list(provider, null),
              _list(provider, ChatType.group),
              _list(provider, ChatType.channel),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreate(context),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _list(TelegramProvider provider, ChatType? type) {
    final chats = provider.chatsOfType(type);
    if (chats.isEmpty) {
      return const Center(child: Text('Sin conversaciones'));
    }
    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final c = chats[index];
        final last = provider.lastMessageFor(c.id!);
        Color color;
        try {
          color = Color(int.parse(c.avatarColor, radix: 16));
        } catch (_) {
          color = Colors.blue;
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(_iconFor(c.type), color: Colors.white),
          ),
          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            last != null
                ? (c.type == ChatType.private ? last.text : '${last.sender}: ${last.text}')
                : c.subtitleLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: last != null
              ? Text(DateFormat('HH:mm').format(last.dateTime),
                  style: const TextStyle(fontSize: 12, color: Colors.grey))
              : null,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatScreen(chat: c)),
          ),
        );
      },
    );
  }

  void _showCreate(BuildContext context) {
    final nameCtrl = TextEditingController();
    ChatType type = ChatType.group;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nueva conversacion',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SegmentedButton<ChatType>(
                segments: const [
                  ButtonSegment(value: ChatType.private, label: Text('Chat'), icon: Icon(Icons.person)),
                  ButtonSegment(value: ChatType.group, label: Text('Grupo'), icon: Icon(Icons.group)),
                  ButtonSegment(value: ChatType.channel, label: Text('Canal'), icon: Icon(Icons.campaign)),
                ],
                selected: {type},
                onSelectionChanged: (s) => setModalState(() => type = s.first),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    final colors = ['FF229ED9', 'FF1B873F', 'FFB3261E', 'FF7D5260'];
                    context.read<TelegramProvider>().addChat(Chat(
                          name: nameCtrl.text.trim(),
                          type: type,
                          members: type == ChatType.private ? 0 : 1,
                          avatarColor: colors[DateTime.now().millisecond % colors.length],
                        ));
                    Navigator.pop(ctx);
                  },
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
