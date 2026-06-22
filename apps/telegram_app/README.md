# telegram_app (tipo Telegram)

App de mensajeria en **Flutter** con base de datos **SQLite local** (`sqflite`).
Soporta tres tipos de conversacion: **chats privados, grupos y canales**.

## Funcionalidades
- Pestanas: Todos / Grupos / Canales (TabBar).
- Chats privados, grupos (con nombre del emisor) y canales (solo lectura).
- Crear nuevas conversaciones eligiendo el tipo (SegmentedButton).
- Mensajes persistentes en SQLite y burbujas estilo Telegram.

## Estructura
```
lib/
  main.dart
  db/database_helper.dart            # chats + messages
  models/chat.dart                   # enum ChatType (private/group/channel)
  models/message.dart
  providers/telegram_provider.dart
  screens/chats_list_screen.dart     # TabBar con filtros por tipo
  screens/chat_screen.dart
```

## Como ejecutar
```bash
cd apps/telegram_app
flutter create .
flutter pub get
flutter run
```
