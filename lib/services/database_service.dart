import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/map_point.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'map_points.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE map_points(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertPoint(MapPoint point) async {
    final db = await database;
    return db.insert('map_points', point.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MapPoint>> getAllPoints() async {
    final db = await database;
    final maps = await db.query('map_points', orderBy: 'id DESC');
    return maps.map(MapPoint.fromMap).toList();
  }

  Future<void> deletePoint(int id) async {
    final db = await database;
    await db.delete('map_points', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePoint(MapPoint point) async {
    final db = await database;
    await db.update('map_points', point.toMap(),
        where: 'id = ?', whereArgs: [point.id]);
  }
}
