import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/map_point.dart';

// singleton pour acceder a la base depuis nimporte ou
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'points.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE points('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'latitude REAL NOT NULL, '
          'longitude REAL NOT NULL)',
        );
      },
    );
  }

  Future<int> ajouterPoint(MapPoint point) async {
    final db = await database;
    return db.insert('points', point.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MapPoint>> getPoints() async {
    final db = await database;
    final liste = await db.query('points', orderBy: 'id DESC');
    return liste.map((e) => MapPoint.fromMap(e)).toList();
  }

  Future<void> supprimerPoint(int id) async {
    final db = await database;
    await db.delete('points', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> modifierPoint(MapPoint point) async {
    final db = await database;
    await db.update(
      'points',
      point.toMap(),
      where: 'id = ?',
      whereArgs: [point.id],
    );
  }
}
