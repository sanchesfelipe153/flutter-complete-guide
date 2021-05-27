import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  DBHelper._();

  static Future<sql.Database> _database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, _) {
        return db.execute(
          'CREATE TABLE user_places('
          'id TEXT PRIMARY KEY, '
          'title TEXT, '
          'image TEXT, '
          'loc_lat REAL, '
          'loc_lng REAL, '
          'address TEXT'
          ')',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    final db = await _database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await _database();
    return db.query(table);
  }

  static Future<int> delete(String table, String where, List<Object?> whereArgs) async {
    final db = await _database();
    return db.delete(table, where: where, whereArgs: whereArgs);
  }
}
