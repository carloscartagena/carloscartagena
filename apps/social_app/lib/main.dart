import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/feed_provider.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedProvider(),
      child: MaterialApp(
        title: 'Social App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFE1306C),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
          ),
          useMaterial3: true,
        ),
        home: const FeedScreen(),
      ),
    );
  }
}
