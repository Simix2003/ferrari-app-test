import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern to ensure a single instance of the database service
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Codes(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL, "
          "name TEXT, surname TEXT, loginTime TEXT, logoutTime TEXT)",
        );
        // Insert your default code here when the table is created
        await insertCode(database, '1234567890', 'Simone', 'Paparo', '', '');
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        // Handle database schema changes here
        if (newVersion > oldVersion) {
          await database.execute("DROP TABLE IF EXISTS Codes");
          await database.execute(
            "CREATE TABLE Codes(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL, "
            "name TEXT, surname TEXT, loginTime TEXT, logoutTime TEXT)",
          );

          // Insert your default code here when the table is created
          await insertCode(database, '1234567890', 'Simone', 'Paparo', '', '');
        }
      },
      version: 2,
    );
  }

  Future<bool> verifyCode(String enteredCode) async {
    try {
      final db = await initializeDB();
      final result = await db.query(
        'Codes',
        where: 'code = ?',
        whereArgs: [enteredCode],
      );

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error verifying code: $e');
      return false; // Return false in case of any errors
    }
  }

  Future<void> insertCode(
    Database db,
    String code,
    String name,
    String surname,
    String loginTime,
    String logoutTime,
  ) async {
    await db.insert(
      'Codes',
      {
        'code': code,
        'name': name,
        'surname': surname,
        'loginTime': loginTime,
        'logoutTime': logoutTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
