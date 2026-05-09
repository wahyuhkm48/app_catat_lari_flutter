import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/run.dart';

class RunDao {
  final AppDatabase _db = AppDatabase();

  Future<void> insertRun(Run run) async {
    final db = await _db.database;
    await db.insert(
      'run_table',
      run.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRun(Run run) async {
    final db = await _db.database;
    await db.update(
      'run_table',
      run.toMap(),
      where: 'id = ?',
      whereArgs: [run.id],
    );
  }

  Future<void> deleteRun(Run run) async {
    final db = await _db.database;
    await db.delete(
      'run_table',
      where: 'id = ?',
      whereArgs: [run.id],
    );
  }

  Future<List<Run>> getAllRuns() async {
    final db = await _db.database;
    final result = await db.query(
      'run_table',
      orderBy: 'id DESC',
    );
    return result.map((map) => Run.fromMap(map)).toList();
  }
}