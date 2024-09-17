import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'quick_recap.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE UserCredentials(
            id INTEGER PRIMARY KEY,
            email TEXT,
            password TEXT,
            rememberMe INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> saveCredentials(String email, String password, bool rememberMe) async {
    final db = await database;
    await db.delete('UserCredentials'); // Clear previous credentials
    await db.insert('UserCredentials', {
      'email': email,
      'password': password,
      'rememberMe': rememberMe ? 1 : 0,
    });
  }

  Future<Map<String, dynamic>?> getCredentials() async {
    final db = await database;
    var results = await db.query('UserCredentials',
        where: 'rememberMe = ?', whereArgs: [1], limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> clearCredentials() async {
    final db = await database;
    await db.delete('UserCredentials');
  }
}