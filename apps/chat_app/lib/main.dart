import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'screens/chats_screen.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF075E54),
          scaffoldBackgroundColor: const Color(0xFFECE5DD),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF075E54),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const ChatsScreen(),
      ),
    );
  }
}
