# chat_app (tipo WhatsApp)

App de mensajeria construida en **Flutter** con base de datos **SQLite local** (`sqflite`).

## Funcionalidades
- Lista de chats con ultimo mensaje y hora.
- Pantalla de conversacion con burbujas (enviado / recibido).
- Auto-respuesta simulada para probar el flujo.
- Crear contactos nuevos y eliminar chats (con sus mensajes).
- Persistencia real: contactos y mensajes se guardan en SQLite.

## Estructura
```
lib/
  main.dart
  db/database_helper.dart      # Esquema + CRUD SQLite
  models/contact.dart
  models/message.dart
  providers/chat_provider.dart # Estado con Provider
  screens/chats_screen.dart
  screens/chat_detail_screen.dart
  widgets/avatar.dart
```

## Como ejecutar
```bash
cd apps/chat_app
flutter create .        # genera carpetas android/ ios/ (solo la primera vez)
flutter pub get
flutter run
```
