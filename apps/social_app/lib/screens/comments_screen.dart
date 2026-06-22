import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _controller = TextEditingController();
  late Future<List<Comment>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = context.read<FeedProvider>().getComments(widget.post.id!);
  }

  Future<void> _send() async {
    final text = _controller.text;
    _controller.clear();
    await context.read<FeedProvider>().addComment(widget.post.id!, text);
    setState(_reload);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data!;
                if (comments.isEmpty) {
                  return const Center(child: Text('Se el primero en comentar'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(c.username.substring(0, 1).toUpperCase()),
                      ),
                      title: Text(c.username,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(c.text),
                      trailing: Text(DateFormat('HH:mm').format(c.dateTime),
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Agrega un comentario...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
