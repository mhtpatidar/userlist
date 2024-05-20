import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/User.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            country TEXT,
            registrationDate TEXT,
            dob TEXT,
            pictureUrl TEXT,
            city TEXT,
            state TEXT,
            postcode TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        name: maps[i]['name'],
        email: maps[i]['email'],
        country: maps[i]['country'],
        registrationDate: DateTime.parse(maps[i]['registrationDate']),
        dob: DateTime.parse(maps[i]['dob']),
        pictureUrl: maps[i]['pictureUrl'],
        city: maps[i]['city'],
        // Parsing 'city' field
        state: maps[i]['state'],
        // Parsing 'state' field
        postcode: maps[i]['postcode'], // Parsing 'postcode' field
      );
    });
  }
}