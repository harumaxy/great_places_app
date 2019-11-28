import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  // dbテーブルを作るときには user_ という接頭辞をつける
  static const tableName = "place";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    // SQLiteでは、 1つの.dbファイル = 1テーブルが望ましい
    // この例では、最初にファイルが無かったときのonCreate()でしかテーブルを作成しないので、問い合わせるテーブル名を途中で変えないようにする
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
