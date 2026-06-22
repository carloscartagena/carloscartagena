# social_app (tipo Instagram)

Red social en **Flutter** con base de datos **SQLite local** (`sqflite`).

## Funcionalidades
- Feed de publicaciones con foto (emoji), pie de foto y fecha.
- Dar / quitar me gusta (persistente en la base de datos).
- Comentarios por publicacion (crear y listar).
- Crear nueva publicacion eligiendo imagen y color de fondo.
- Pantalla de perfil con grilla de mis publicaciones y estadisticas.

## Estructura
```
lib/
  main.dart
  db/database_helper.dart        # posts + comments
  models/post.dart
  models/comment.dart
  providers/feed_provider.dart
  widgets/post_card.dart
  screens/feed_screen.dart
  screens/create_post_screen.dart
  screens/comments_screen.dart
  screens/profile_screen.dart
```

## Como ejecutar
```bash
cd apps/social_app
flutter create .
flutter pub get
flutter run
```
