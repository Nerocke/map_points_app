# map_points_app

Application Flutter qui permet de placer des points nommés sur une carte OpenStreetMap et de les voir en liste. Les données sont sauvegardées en base SQLite.

## Captures d'écran

| Carte | Liste |
|:---:|:---:|
| ![Carte](screenshots/01_map_with_points.png) | ![Liste](screenshots/02_list_screen.png) |

## Fonctionnalités

- Carte OSM interactive (pas besoin de clé API)
- Tap sur la carte pour ajouter un point avec un nom
- Marqueurs affichés directement sur la carte
- Vue liste scrollable de tous les points
- Renommer ou supprimer un point depuis la liste
- Mini-carte pour localiser un point depuis la liste
- Stockage persistant en SQLite (via sqflite)

## Stack

- Flutter 3.x
- flutter_map + OpenStreetMap pour la carte
- sqflite pour la base de données locale

## Lancer le projet

```bash
git clone https://github.com/Nerocke/map_points_app.git
cd map_points_app
flutter pub get
flutter run
```

> Prérequis : Flutter SDK installé, et CocoaPods pour iOS (`brew install cocoapods`)

## Structure

```
lib/
├── main.dart
├── models/
│   └── map_point.dart
├── services/
│   └── database_service.dart
└── screens/
    ├── map_screen.dart
    └── list_screen.dart
```
