import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/models/index.dart';
import 'package:sqflite/sqflite.dart';

class CostsRepo {
  static const diKey = 'CostsRepo';
  final Database _database;
  final String _tableName = 'Costs';
  final _logger = createLogger(diKey);

  CostsRepo(this._database);

  Future<List<CostItem>> queryBetween(int from, int to) async {
    final results = await _database.query(
      _tableName,
      where: 'dateStamp >= ? AND dateStamp <= ?',
      whereArgs: [from, to],
    );
    return results.map((e) => CostItem.fromMap(e)).toList();
  }

  Future<CostItem?> query(String id) async {
    final result = await _database.query(_tableName,
        where: 'id = ?', whereArgs: [id], limit: 1);

    if (result.length != 1) {
      return null;
    }
    return CostItem.fromMap(result[0]);
  }

  Future<void> updateOrInsert(CostItem item) async {
    final result = await _database.update(
      _tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    if (result == 0) {
      await _database.insert(_tableName, item.toMap());
    }
  }

  Future<void> updateOrInsertMany(List<CostItem> costs) async {
    final futures = costs.map((cost) => updateOrInsert(cost));

    await Future.wait(futures);
  }

  Future<void> delete(String id) async {
    await _database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
