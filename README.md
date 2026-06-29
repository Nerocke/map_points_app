# Map Points App 🗺️

Application Flutter permettant de placer des points nommés sur une carte OpenStreetMap et de les consulter en liste. Les données sont persistées en base SQLite locale.

## Fonctionnalités

- **Carte interactive OSM** — affichage OpenStreetMap sans clé API
- **Placement de points** — un tap sur la carte ouvre un dialogue pour nommer le point
- **Marqueurs personnalisés** — chaque marqueur affiche son nom sur la carte
- **Liste scrollable** — vue liste de tous les points avec coordonnées
- **Mini-carte** — aperçu cartographique de chaque point depuis la liste
- **Renommer / Supprimer** — édition depuis la carte ou la liste
- **Persistance SQLite** — stockage local via sqflite

## Captures d'écran

| Carte avec points | Liste des points |
|:---:|:---:|
| ![Carte](screenshots/01_map_with_points.png) | ![Liste](screenshots/02_list_screen.png) |

## Stack technique

| Couche | Technologie |
|--------|------------|
| Framework | Flutter 3.x |
| Carte | `flutter_map` + tuiles OpenStreetMap |
| Coordonnées | `latlong2` |
| Base de données | `sqflite` (SQLite) |
| Plateforme | iOS & Android |

## Structure du projet

```
lib/
├── main.dart                    # Point d'entrée
├── models/
│   └── map_point.dart           # Modèle de données
├── services/
│   └── database_service.dart    # CRUD SQLite (singleton)
└── screens/
    ├── map_screen.dart          # Écran carte principal
    └── list_screen.dart         # Écran liste des points
```

## Lancer le projet

### Prérequis

- Flutter SDK ≥ 3.0 — [Installation](https://docs.flutter.dev/get-started/install)
- Xcode (iOS) ou Android Studio (Android)
- CocoaPods (iOS) : `brew install cocoapods`

### Commandes

```bash
# Cloner le repo
git clone https://github.com/EthanAllouche/map_points_app.git
cd map_points_app

# Installer les dépendances
flutter pub get

# Lancer sur simulateur/émulateur
flutter run

# Lancer sur un device spécifique
flutter run -d <device_id>
```

### Lister les devices disponibles

```bash
flutter devices
```

## Utilisation

1. **Ajouter un point** : appuie sur n'importe quel endroit de la carte → entre un nom → confirme
2. **Voir les détails** : tape sur un marqueur → options (supprimer)
3. **Vue liste** : icône ≡ en haut à droite → liste scrollable de tous les points
4. **Mini-carte** : tape sur un élément de la liste pour voir sa localisation
5. **Renommer** : icône ✎ dans la liste
6. **Supprimer** : icône 🗑 dans la liste ou depuis le marqueur

## Dépendances

```yaml
flutter_map: ^7.0.2      # Carte OSM
latlong2: ^0.9.1         # Lat/Lng
sqflite: ^2.3.3+1        # SQLite
path: ^1.9.0             # Chemin DB
uuid: ^4.4.0             # Identifiants uniques
```

## Auteur

Ethan Allouche — ethan.allouche290759@gmail.com
