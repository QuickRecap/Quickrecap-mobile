import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user.dart';


class LocalStorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    print("Database path: $path");
    return await openDatabase(
      join(path, 'quick_recap.db'),
      onCreate: (db, version) async {
        print("Creating database tables...");
        await db.execute('''        
        CREATE TABLE IF NOT EXISTS UserCredentials(
          id INTEGER PRIMARY KEY,
          email TEXT,
          password TEXT,
          rememberMe INTEGER
        )
      ''');

        await db.execute(''' 
        CREATE TABLE IF NOT EXISTS User(
          id TEXT PRIMARY KEY, 
          first_name TEXT,
          last_name TEXT,
          gender TEXT,
          phone TEXT,
          email TEXT,
          birthday TEXT,
          profile_image TEXT
        )
      ''');
        print("Database tables created successfully.");
      },
      onOpen: (db) async {
        print("Database opened. Checking tables...");
        var tables = await db.query('sqlite_master', columns: ['name']);
        print("Existing tables: ${tables.map((t) => t['name']).toList()}");

        // Force creation of User table if it doesn't exist
        await db.execute(''' 
        CREATE TABLE IF NOT EXISTS User(
          id TEXT PRIMARY KEY, 
          first_name TEXT,
          last_name TEXT,
          gender TEXT,
          phone TEXT,
          email TEXT,
          birthday TEXT,
          profile_image TEXT
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

  Future saveUser(User user) async {
    final db = await database;

    // Limpiar la tabla antes de insertar un nuevo usuario
    await db.delete('User');

    // Insertar el nuevo usuario
    await db.insert(
      'User',
      {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'gender': user.gender,
        'phone': user.phone,
        'email': user.email,
        'birthday': user.birthday,
        'profile_image': user.profileImg,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Reemplaza el registro si ya existe
    );
  }


  Future<void> updateUser(User user) async {
    final db = await database;

    await db.update(
      'User',
      {
        'first_name': user.firstName,
        'last_name': user.lastName,
        'gender': user.gender,
        'phone': user.phone,
        'email': user.email,
        'birthday': user.birthday,
        'profile_image': user.profileImg,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }


  Future<User?> getCurrentUser() async {
    final db = await database;
    var results = await db.query('User', limit: 1);

    print("Resultados de la consulta: $results"); // Depuración

    if (results.isNotEmpty) {
      return User(
        id: results.first['id'] as String,
        firstName: results.first['first_name'] as String,
        lastName: results.first['last_name'] as String,
        gender: results.first['gender'] as String,
        phone: results.first['phone'] as String,
        email: results.first['email'] as String,
        birthday: results.first['birthday'] as String,
        profileImg: results.first['profile_image'] as String,
      );
    }
    return null;
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

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('User');
  }
}
