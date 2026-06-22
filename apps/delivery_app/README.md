# delivery_app (tipo PedidosYa)

App de pedidos a domicilio en **Flutter** con base de datos **SQLite local** (`sqflite`).

## Funcionalidades
- Listado de restaurantes (rating, tiempo y costo de envio).
- Menu por restaurante con productos y precios.
- Carrito de compras con cantidades (+/-) y total en vivo.
- Checkout que guarda el pedido en la base de datos.
- Historial de pedidos persistente.

## Estructura
```
lib/
  main.dart
  db/database_helper.dart       # Esquema + datos demo + CRUD
  models/restaurant.dart
  models/product.dart
  models/order.dart
  providers/cart_provider.dart  # Estado del carrito
  screens/home_screen.dart
  screens/restaurant_screen.dart
  screens/cart_screen.dart
  screens/orders_screen.dart
```

## Como ejecutar
```bash
cd apps/delivery_app
flutter create .
flutter pub get
flutter run
```
