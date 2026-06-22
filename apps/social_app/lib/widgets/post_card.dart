import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/feed_provider.dart';
import '../screens/comments_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  Color _color(String hex, Color fallback) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: _color(post.avatarColor, Colors.purple),
            child: Text(post.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.more_horiz),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: _color(post.bgColor, Colors.grey.shade200),
            child: Center(child: Text(post.imageEmoji, style: const TextStyle(fontSize: 96))),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                post.likedByMe ? Icons.favorite : Icons.favorite_border,
                color: post.likedByMe ? Colors.red : null,
              ),
              onPressed: () => provider.toggleLike(post),
            ),
            IconButton(
              icon: const Icon(Icons.mode_comment_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CommentsScreen(post: post)),
              ),
            ),
            IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
            const Spacer(),
            IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${post.likes} me gusta',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                        text: '${post.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CommentsScreen(post: post)),
                ),
                child: Text(
                  'Ver los ${provider.commentCountFor(post.id ?? 0)} comentarios',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              Text(DateFormat('dd MMM, HH:mm').format(post.dateTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
