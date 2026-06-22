import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionCtrl = TextEditingController();
  final _emojis = ['🏞️', '🥟', '💻', '🐶', '🌮', '🎸', '⚽', '🌸', '🏔️', '📸'];
  final _bgColors = ['FFFFE0B2', 'FFFFCDD2', 'FFBBDEFB', 'FFC8E6C9', 'FFE1BEE7'];
  String _selectedEmoji = '📸';
  String _selectedBg = 'FFBBDEFB';

  Color _color(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.grey.shade200;
    }
  }

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicacion'),
        actions: [
          TextButton(
            onPressed: () async {
              await context
                  .read<FeedProvider>()
                  .createPost(_captionCtrl.text.trim(), _selectedEmoji, _selectedBg);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Compartir'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: _color(_selectedBg),
              child: Center(child: Text(_selectedEmoji, style: const TextStyle(fontSize: 96))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Elige una imagen', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _emojis
                .map((e) => GestureDetector(
                      onTap: () => setState(() => _selectedEmoji = e),
                      child: CircleAvatar(
                        backgroundColor:
                            _selectedEmoji == e ? Colors.blue.shade100 : Colors.grey.shade200,
                        child: Text(e, style: const TextStyle(fontSize: 22)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text('Color de fondo', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: _bgColors
                .map((c) => GestureDetector(
                      onTap: () => setState(() => _selectedBg = c),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _color(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedBg == c ? Colors.blue : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _captionCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Escribe un pie de foto...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
