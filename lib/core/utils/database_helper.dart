import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'wardy.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create clothing items table
    await db.execute('''
      CREATE TABLE clothing_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        category TEXT NOT NULL,
        color TEXT NOT NULL,
        occasions TEXT NOT NULL,
        seasons TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        dateAdded INTEGER NOT NULL,
        brand TEXT,
        attributes TEXT
      )
    ''');

    // Create outfit recommendations table
    await db.execute('''
      CREATE TABLE outfit_recommendations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        clothingItemIds TEXT NOT NULL,
        occasion TEXT NOT NULL,
        weather TEXT NOT NULL,
        season TEXT NOT NULL,
        rating INTEGER NOT NULL DEFAULT 0,
        commentary TEXT,
        createdAt INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        additionalInfo TEXT
      )
    ''');

    // Create user preferences table
    await db.execute('''
      CREATE TABLE user_preferences(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL
      )
    ''');
  }

  // ---- Clothing Items CRUD Operations ----

  Future<int> insertClothingItem(Map<String, dynamic> clothingItem) async {
    Database db = await database;
    return await db.insert('clothing_items', clothingItem);
  }

  Future<List<Map<String, dynamic>>> getClothingItems() async {
    Database db = await database;
    return await db.query('clothing_items');
  }

  Future<List<Map<String, dynamic>>> getClothingItemsByCategory(
    String category,
  ) async {
    Database db = await database;
    return await db.query(
      'clothing_items',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> updateClothingItem(Map<String, dynamic> clothingItem) async {
    Database db = await database;
    return await db.update(
      'clothing_items',
      clothingItem,
      where: 'id = ?',
      whereArgs: [clothingItem['id']],
    );
  }

  Future<int> deleteClothingItem(int id) async {
    Database db = await database;
    return await db.delete('clothing_items', where: 'id = ?', whereArgs: [id]);
  }

  // ---- Outfit Recommendations CRUD Operations ----

  Future<int> insertOutfitRecommendation(
    Map<String, dynamic> recommendation,
  ) async {
    Database db = await database;
    return await db.insert('outfit_recommendations', recommendation);
  }

  Future<List<Map<String, dynamic>>> getOutfitRecommendations() async {
    Database db = await database;
    return await db.query('outfit_recommendations', orderBy: 'createdAt DESC');
  }

  Future<int> updateOutfitRecommendation(
    Map<String, dynamic> recommendation,
  ) async {
    Database db = await database;
    return await db.update(
      'outfit_recommendations',
      recommendation,
      where: 'id = ?',
      whereArgs: [recommendation['id']],
    );
  }

  Future<int> deleteOutfitRecommendation(int id) async {
    Database db = await database;
    return await db.delete(
      'outfit_recommendations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---- User Preferences Operations ----

  Future<void> setPreference(String key, String value) async {
    Database db = await database;
    await db.insert('user_preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getPreference(String key) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['value'] as String;
  }
}
