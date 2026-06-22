import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/feed_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Color _color(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    final myPosts =
        provider.posts.where((p) => p.username == provider.currentUser).toList();
    final totalLikes = myPosts.fold<int>(0, (sum, p) => sum + p.likes);

    return Scaffold(
      appBar: AppBar(title: Text(provider.currentUser)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(width: 24),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('${myPosts.length}', 'Posts'),
                      _stat('$totalLikes', 'Likes'),
                      _stat('312', 'Seguidores'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Mi usuario\nConstruyendo apps en Flutter 💙',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Divider(height: 32),
          if (myPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Aun no has publicado nada')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final Post p = myPosts[index];
                return Container(
                  color: _color(p.bgColor),
                  child: Center(child: Text(p.imageEmoji, style: const TextStyle(fontSize: 40))),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
