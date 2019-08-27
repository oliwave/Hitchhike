import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  DatabaseHandler._();

  factory DatabaseHandler() {
    return _databaseHandler;
  }

  static final _databaseHandler = DatabaseHandler._();

  static const String favoriteRoutes = 'FavoriteRoutes';

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
        addressEnd TEXT
      )
    """,
  };

  Database get db => _db;

  Database _db;
  String _dirPath;

  Future<void> init() async {
    // provide by path_provider package to get a path of folder on our mobile device
    // where we can save our data.
    _dirPath = (await getApplicationDocumentsDirectory()).path;

    // documentsDirectory.path/items.db
    final dbPath = join(_dirPath, "hitchhike.db");

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute(_tables[favoriteRoutes]);
      },
    );
  }
}
