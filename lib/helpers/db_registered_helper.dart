import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:promaparams_app/models/models.dart';
export 'package:promaparams_app/models/models.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_proma_params_granjas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Crear tabla para registros
        await db.execute('''
          CREATE TABLE registros(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            secRegistro INTEGER ,
            codCamaronera TEXT,
            descCamaronera TEXT,
            codFormParametro INTEGER,
            descFormParametro TEXT,
            fecRegistro TEXT,
            estadoRegistro TEXT,
            anio INTEGER,
            piscina TEXT,
            despiscina TEXT,
            ciclo TEXT,
            sincronizado INTEGER
          )
        ''');

        // Crear tabla para variables
        await db.execute('''
          CREATE TABLE variables(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario TEXT,
            codCamaronera TEXT,
            descCamaronera TEXT,
            codParametro TEXT,
            descParametro TEXT,
            codVariable TEXT,
            tipoDato TEXT,
            nombre TEXT,
            valorVariable TEXT
          )
        ''');

        // Crear tabla para detalle registros/variables
        await db.execute('''
          CREATE TABLE detalleregistros(
            secuencia INTEGER PRIMARY KEY AUTOINCREMENT,
            id INTEGER, 
            secRegistro ,
            codCamaronera TEXT,
            descCamaronera TEXT,
            codFormParametro INTEGER,
            descFormParametro TEXT,
            fecRegistro TEXT,
            estadoRegistro TEXT,
            anio INTEGER,
            piscina TEXT,
            despiscina TEXT,
            ciclo TEXT,
            codVariable TEXT,
            tipoDato TEXT,
            nombre TEXT,
            valorVariable TEXT,
            sincronizado INTEGER
          )
        ''');
      },
    );
  }

  // Métodos para registros

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

  Future<List<Registro>> getRegistrosPorCamaroneraYParametro(
      String codCamaronera, int codFormParametro) async {
    final db = await database;
    final res = await db.query(
      'registros',
      where: 'codCamaronera = ? AND codFormParametro = ?',
      whereArgs: [codCamaronera, codFormParametro],
    );
    return res.isNotEmpty ? res.map((e) => Registro.fromMap(e)).toList() : [];
  }

  Future<void> insertRegistroPorCamaroneraYParametro(
      Registro registro, String codCamaronera, int codFormParametro) async {
    final db = await database;
    await db.insert(
      'registros',
      registro.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertRegistroPorCamaroneraYParametroCab(
      Registro registro, String codCamaronera, int codFormParametro) async {
    final db = await database;
    // Insertar en la tabla 'registros'
    int idRegistro = await db.insert(
        'registros', registro.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idRegistro;
  }

  Future<void> updateRegistroPorCamaroneraYParametro(
      Registro registro, String codCamaronera, int codFormParametro) async {
    final db = await database;
    await db.update(
      'registros',
      registro.toMap(),
      where: 'codCamaronera = ? AND codFormParametro = ?',
      whereArgs: [codCamaronera, codFormParametro],
    );
  }

  Future<void> deleteRegistroPorCamaroneraYParametro(
      String codCamaronera, int codFormParametro) async {
    final db = await database;
    await db.delete(
      'registros',
      where: 'sincronizado=1 And codCamaronera = ? AND codFormParametro = ?  ',
      whereArgs: [codCamaronera, codFormParametro],
    );
  }

  Future<List<Registro>> getRegistros() async {
    final db = await database;
    final res = await db.query('registros');
    return res.isNotEmpty ? res.map((e) => Registro.fromMap(e)).toList() : [];
  }

  // Obtener Cabecera de registros por Id del Registro de cabecera
  Future<List<Registro>> getCabeceraPorId(int id) async {
    final db = await database;
    final res = await db.query(
      'registros',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.map((e) => Registro.fromMap(e)).toList() : [];
  }

  // Métodos para variables

  Future<void> insertVariable(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('variables', data);
  }

  Future<void> updateVariable(Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'variables',
      {'valorVariable': data['valorVariable']},
      where: 'codParametro = ? AND codVariable = ?',
      whereArgs: [data['codParametro'], data['codVariable']],
    );
  }

  Future<void> deleteAllVariables() async {
    final db = await database;
    await db.delete('variables');
  }

  Future<List<Map<String, dynamic>>> getVariables() async {
    final db = await database;
    final res = await db.query('variables');
    return res.isNotEmpty ? res : [];
  }

  Future<int> insertarRegistrosDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    final db = await database;

    // Insertar en la tabla 'registros'
    int idRegistro = await db.insert(
        'registros', registro.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace);

    // Iterar sobre la lista de detalles y asociar el id del registro
    for (var detalle in detalles) {
      Map<String, dynamic> detalleData = detalle.toMap();
      detalleData['id'] = idRegistro; // Asociar el id del registro principal
      await db.insert('detalleregistros', detalleData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return idRegistro;
  }

  Future<int> insertarRegistrosPorCamaroneraYDetalle(
      List<DetalleRegistro> detalles, int idRegistro) async {
    final db = await database;
    /*
    * Iterar sobre la lista de detalles y asociar el id del registro 
    */
    for (var detalle in detalles) {
      Map<String, dynamic> detalleData = detalle.toMap();
      /*
      * Remover el campo 'secuencia' para que SQLite lo gestione como autoincrement
      */
      detalleData.remove('secuencia');
      /*
      * Asociar el id del registro principal 
      */
      detalleData['id'] = idRegistro;
      await db.insert('detalleregistros', detalleData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return idRegistro;
  }

  Future<void> updateRegistroDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    final db = await database;
    // Actualizar detalles del registro
    for (var detalle in detalles) {
      await db.update(
        'detalleregistros',
        detalle.toMap(),
        where: 'secRegistro = ? AND codVariable = ? AND codFormParametro = ?',
        whereArgs: [
          detalle.secRegistro,
          detalle.codVariable,
          detalle.codFormParametro,
        ],
      );
    }
  }

  Future<void> updateDetalleValorVariable(Map<String, dynamic> detalles) async {
    final db = await database;
    await db.update(
      'detalleregistros',
      {'valorVariable': detalles['valorVariable']},
      where:
          'codFormParametro = ? AND codVariable = ? And codCamaronera=? And id=?',
      whereArgs: [
        detalles['codParametro'],
        detalles['codVariable'],
        detalles['codCamaronera'],
        detalles['id']
      ],
    );
  }

  Future<void> updateRegistroDetalleXId(List<DetalleRegistro> detalles) async {
    final db = await database;
    // Actualizar detalles del registro
    for (var detalle in detalles) {
      await db.update(
        'detalleregistros',
        detalle.toMap(),
        where:
            'id = ? AND codVariable = ? AND codFormParametro = ? And codCamaronera = ?',
        whereArgs: [
          detalle.id,
          detalle.codVariable,
          detalle.codFormParametro,
          detalle.codCamaronera,
        ],
      );
    }
  }

  Future<void> deleteRegistroDetalle(
      int secRegistro, String codVariable, int codFormParametro) async {
    final db = await database;
    // Eliminar detalles relacionados de la tabla 'detalleregistros'
    await db.delete(
      'detalleregistros',
      where: 'secRegistro = ? AND codVariable = ? AND codFormParametro = ?',
      whereArgs: [secRegistro, codVariable, codFormParametro],
    );
  }

  // Obtener detalles de registros por secRegistro
  Future<List<DetalleRegistro>> getDetallesPorSecRegistro(
      int secRegistro) async {
    final db = await database;
    final res = await db.query(
      'detalleregistros',
      where: 'secRegistro = ?',
      whereArgs: [secRegistro],
    );
    return res.isNotEmpty
        ? res.map((e) => DetalleRegistro.fromMap(e)).toList()
        : [];
  }

  // Obtener detalles de registros por Id del Registro de cabecera
  Future<List<DetalleRegistro>> getDetallesPorId(int id) async {
    final db = await database;
    final res = await db.query(
      'detalleregistros',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty
        ? res.map((e) => DetalleRegistro.fromMap(e)).toList()
        : [];
  }

  // Obtener detalles de registros por codVariable
  Future<List<DetalleRegistro>> getDetallesPorCodVariable(
      String codVariable) async {
    final db = await database;
    final res = await db.query(
      'detalleregistros',
      where: 'codVariable = ?',
      whereArgs: [codVariable],
    );
    return res.isNotEmpty
        ? res.map((e) => DetalleRegistro.fromMap(e)).toList()
        : [];
  }

  // Método para actualizar el estado de sincronización en la tabla 'registros' y 'detalleregistros'
  Future<void> marcarComoSincronizado(int id) async {
    final db = await database;

    // Actualizar el campo 'sincronizado' en la tabla 'registros'
    await db.update(
      'registros',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    // Actualizar el campo 'sincronizado' en la tabla 'detalleregistros'
    await db.update(
      'detalleregistros',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
