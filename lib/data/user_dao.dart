import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../models/user.dart';

class UserDao {
  final AppDatabase _db = AppDatabase();

  Future<void> insert(User user) async {
    final db = await _db.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<User?> login(String email, String password) async {
    final db = await _db.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}