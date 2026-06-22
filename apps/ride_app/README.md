# ride_app (tipo Uber)

App de viajes (ride-hailing) en **Flutter** con base de datos **SQLite local** (`sqflite`).

## Funcionalidades
- Ingreso de origen y destino con calculo de distancia (simulado).
- Seleccion de categoria de viaje (Economy / Comfort / XL) con tarifa dinamica.
- Asignacion de conductor desde la base de datos.
- Pantalla de viaje en curso con datos del conductor y vehiculo.
- Finalizacion del viaje que guarda el registro en SQLite.
- Historial de viajes persistente.

> Nota: el mapa es un placeholder visual. Para mapas reales se integraria
> `google_maps_flutter` + API Key (requiere conexion a internet).

## Estructura
```
lib/
  main.dart
  db/database_helper.dart        # drivers + trips
  models/driver.dart
  models/trip.dart
  models/ride_option.dart        # tarifas por categoria
  providers/ride_provider.dart
  screens/home_screen.dart
  screens/searching_screen.dart
  screens/trip_active_screen.dart
  screens/trips_screen.dart
```

## Como ejecutar
```bash
cd apps/ride_app
flutter create .
flutter pub get
flutter run
```
