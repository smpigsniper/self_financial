// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:self_financial/Model/Request/amount_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "self_financial.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE AMOUNT(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, amount NUMERIC(6, 2) NOT NULL, created_at TEXT DEFAULT CURRENT_TIMESTAMP );"),
      version: _version,
    );
  }

  Future<int> addAmount(AmountModel requestAmountModel) async {
    final db = await _getDB();
    return await db.insert(
      "AMOUNT",
      requestAmountModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateAmount(AmountModel requestAmountModel) async {
    final db = await _getDB();
    return await db.update("AMOUNT", requestAmountModel.toJson(),
        where: 'id = ?',
        whereArgs: [requestAmountModel.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteAmount(AmountModel requestAmountModel) async {
    final db = await _getDB();
    return await db.delete(
      "AMOUNT",
      where: "id = ?",
      whereArgs: [requestAmountModel.id],
    );
  }

  static Future<List<AmountModel>> getAllAmount() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("AMOUNT");

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (index) => AmountModel.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<AmountModel>> getAmountWithMonth(
      DateTime startDate, DateTime endDate) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      "AMOUNT",
      where: "created_at between ? AND ?",
      whereArgs: [startDate, endDate],
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
      maps.length,
      (index) => AmountModel.fromJson(maps[index]),
    );
  }
}
