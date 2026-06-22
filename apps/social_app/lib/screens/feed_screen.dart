import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram',
            style: TextStyle(fontFamily: 'cursive', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, provider, _) {
          if (provider.posts.isEmpty) {
            return const Center(child: Text('No hay publicaciones aun'));
          }
          return RefreshIndicator(
            onRefresh: provider.loadPosts,
            child: ListView.builder(
              itemCount: provider.posts.length,
              itemBuilder: (context, index) => PostCard(post: provider.posts[index]),
            ),
          );
        },
      ),
    );
  }
}
