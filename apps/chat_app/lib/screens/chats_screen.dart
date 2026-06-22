import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../providers/chat_provider.dart';
import '../widgets/avatar.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (provider.contacts.isEmpty) {
            return const Center(child: Text('No hay chats. Agrega un contacto.'));
          }
          return ListView.separated(
            itemCount: provider.contacts.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, index) {
              final c = provider.contacts[index];
              final last = provider.lastMessageFor(c.id!);
              return ListTile(
                leading: Avatar(initials: c.initials, colorHex: c.avatarColor),
                title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  last?.text ?? 'Sin mensajes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: last != null
                    ? Text(
                        DateFormat('HH:mm').format(last.dateTime),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : null,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(contact: c),
                  ),
                ),
                onLongPress: () => _confirmDelete(context, provider, c),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContact(context),
        child: const Icon(Icons.chat),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ChatProvider provider, Contact c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar ${c.name}?'),
        content: const Text('Se borraran todos los mensajes de este chat.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              provider.deleteContact(c.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showAddContact(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final colors = ['FF6750A4', 'FF1B873F', 'FFB3261E', 'FF7D5260', 'FF006A6A'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nuevo contacto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefono', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) return;
                  final color = colors[DateTime.now().millisecond % colors.length];
                  context.read<ChatProvider>().addContact(Contact(
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        avatarColor: color,
                      ));
                  Navigator.pop(ctx);
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
