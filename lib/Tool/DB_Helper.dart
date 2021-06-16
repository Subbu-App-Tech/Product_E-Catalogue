import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbpath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbpath, 'product.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  static void _createDb(Database db) {
    db.execute('''CREATE TABLE product_data ( id TEXT PRIMARY KEY,name TEXT,
          description TEXT,imageurl TEXT, catlist TEXT, brand TEXT, fav TEXT,rank INTEGER)''');
    db.execute('CREATE TABLE catdata ( id TEXT PRIMARY KEY,name TEXT)');
    db.execute('''CREATE TABLE varietydata 
        ( id TEXT PRIMARY KEY,productid TEXT ,name TEXT,price DOUBLE,wsp DOUBLE)''');
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

  static Future<int> updateData(String table, var newdata) async {
    final db = await DBHelper.database();
    return db.update(table, newdata.toMap(),
        where: "id = ?", whereArgs: [newdata.id]);
  }

  static Future<void> deleteall(String table) async {
    final db = await DBHelper.database();
    return db.execute("delete from " + table);
  }

  static Future<int> delete(String table, String? id) async {
    final db = await DBHelper.database();
    return db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deletevariery(String table, String id) async {
    final db = await DBHelper.database();
    return db.delete(table, where: "productid = ?", whereArgs: [id]);
  }
}
