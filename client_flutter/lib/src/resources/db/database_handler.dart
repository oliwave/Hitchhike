import 'package:sqflite/sqflite.dart';
import '../file/directory_access.dart';

class DatabaseHandler {
  DatabaseHandler._();

  factory DatabaseHandler() {
    return _databaseHandler;
  }

  static final _databaseHandler = DatabaseHandler._();

  static const String favoriteRoutes = 'FavoriteRoutes';
  static const String chatRecords = 'chatRecords';
  static const String friends = 'friends';

  static const _tables = <String, String>{
    favoriteRoutes: """ 
      CREATE TABLE $favoriteRoutes (
        id INTEGER PRIMARY_KEY,
        isDefaultRoute INTEGER,
        geoStart TEXT,
        geoEnd TEXT,
        nameStart TEXT,
        nameEnd TEXT,
        addressStart TEXT,
        addressEnd TEXT,
        startID TEXT,
        endID TEXT
      )
    """,
    friends: """
      CREATE TABLE $friends (
        room TEXT PRIMARY_KEY,
        name TEXT,
        avatar TEXT,
        hasNewMessage INTEGER
      )
    """,
    chatRecords: """ 
      CREATE TABLE $chatRecords (
        room TEXT FOREIGN_KEY,
        time INTEGER,
        character TEXT,
        text TEXT
      )
    """,
  };

  Database get db => _db;

  Database _db;

  Future<void> init() async {
    // documentsDirectory.path/items.db
    final dbPath = DirectoryAccess.getFilePath('hitchhike.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute(_tables[favoriteRoutes]);
        newDb.execute(_tables[chatRecords]);
        newDb.execute(_tables[friends]);
      },
    );
  }
}
