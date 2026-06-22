import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/telegram_provider.dart';
import 'screens/chats_list_screen.dart';

void main() {
  runApp(const TelegramApp());
}

class TelegramApp extends StatelessWidget {
  const TelegramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TelegramProvider(),
      child: MaterialApp(
        title: 'Telegram App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF229ED9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF229ED9),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const ChatsListScreen(),
      ),
    );
  }
}
