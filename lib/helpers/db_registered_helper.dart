import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:promaparams_app/models/models.dart';

class DBHelperRegisteredParams {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'registros.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE registros(
            secRegistro INTEGER PRIMARY KEY,
            codCamaronera TEXT,
            descCamaronera TEXT,
            codFormParametro INTEGER,
            descFormParametro TEXT,
            fecRegistro TEXT,
            estadoRegistro TEXT,
            anio INTEGER,
            piscina TEXT,
            ciclo TEXT,
            sincronizado INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertRegistro(Registro registro) async {
    final db = await database;
    await db.insert('registros', registro.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateRegistro(Registro registro) async {
    final db = await database;
    await db.update(
      'registros',
      registro.toMap(),
      where: 'secRegistro = ?',
      whereArgs: [registro.secRegistro],
    );
  }

  Future<void> deleteRegistro(int secRegistro) async {
    final db = await database;
    await db.delete(
      'registros',
      where: 'secRegistro = ?',
      whereArgs: [secRegistro],
    );
  }

  Future<List<Registro>> getRegistros() async {
    final db = await database;
    final res = await db.query('registros');
    return res.isNotEmpty ? res.map((e) => Registro.fromMap(e)).toList() : [];
  }
}
