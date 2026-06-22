# Apps Flutter

Coleccion de **5 aplicaciones moviles construidas en Flutter (Dart)**, cada una
con **base de datos SQLite local** (`sqflite`) y manejo de estado con `provider`.

Son MVPs funcionales con datos de ejemplo (seed) que se guardan de forma
persistente en el dispositivo.

| # | App | Inspirada en | Que hace |
|---|-----|--------------|----------|
| 1 | [`chat_app`](./chat_app) | WhatsApp | Chats 1 a 1, mensajes persistentes, auto-respuesta, alta de contactos |
| 2 | [`delivery_app`](./delivery_app) | PedidosYa | Restaurantes, menus, carrito y pedidos guardados |
| 3 | [`ride_app`](./ride_app) | Uber | Solicitud de viaje, categorias y tarifa, asignacion de conductor, historial |
| 4 | [`telegram_app`](./telegram_app) | Telegram | Chats, grupos y canales (con pestanas y modo solo lectura) |
| 5 | [`social_app`](./social_app) | Instagram | Feed, likes, comentarios, crear post y perfil |

## Stack comun

- **Flutter** (Dart `>=3.0.0`)
- **sqflite** — base de datos SQLite local
- **provider** — manejo de estado
- **intl** — formato de fechas

## Como ejecutar cualquier app

> Requiere tener instalado el [SDK de Flutter](https://docs.flutter.dev/get-started/install).

```bash
cd apps/<nombre_de_la_app>     # ej: cd apps/chat_app
flutter create .               # genera carpetas android/ ios/ (solo la 1ra vez)
flutter pub get                # descarga dependencias
flutter run                    # ejecuta en emulador o dispositivo
```

### Notas
- Las carpetas de plataforma (`android/`, `ios/`) **no se versionan** para mantener
  el repositorio liviano; se regeneran con `flutter create .`.
- La base de datos se crea automaticamente en el primer arranque con datos de
  ejemplo.
- En `ride_app` el mapa es un placeholder visual; para mapas reales se integraria
  `google_maps_flutter` (requiere API Key e internet).

---
Generado como demo de portafolio. Stack: Flutter + SQLite.
