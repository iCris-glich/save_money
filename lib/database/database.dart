import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finanzas.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movimientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        monto REAL NOT NULL,
        categoria TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarMovimiento(Map<String, dynamic> movimiento) async {
    final db = await database;
    return await db.insert('movimientos', movimiento);
  }

  Future<int> quitarMovimiento(int id) async {
    final db = await database;
    return await db.delete('movimientos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> obtenerMovimientos() async {
    final db = await database;
    return await db.query('movimientos', orderBy: 'fecha DESC');
  }

  Future<List<Map<String, dynamic>>> totalPorMes() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT 
      strftime('%Y-%m', fecha) as mes,
      SUM(
        CASE 
          WHEN tipo = 'ingreso' THEN monto 
          ELSE -monto 
        END
      ) as total
    FROM movimientos
    GROUP BY mes
    ORDER BY mes
  ''');
  }
}
