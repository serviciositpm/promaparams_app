import 'package:flutter/material.dart';
import 'package:promaparams_app/models/models.dart';
import 'package:promaparams_app/services/services.dart';
import 'package:promaparams_app/helpers/helpers.dart';

class RegisteredParameteresProvider with ChangeNotifier {
  List<Registro> _registros = [];
  bool isLoading = false;
  final ApiServiceRegisteredParams _apiService = ApiServiceRegisteredParams();
  final DBHelperRegisteredParams _dbHelper = DBHelperRegisteredParams();

  List<Registro> get registros => _registros;

  Future<void> loadRegistros(
    String codCamaronera,
    String codParametro,
    int anio,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      // Llama al API
      final response = await _apiService.obtenerRegistrosParametros(
        opcion: 'CRP',
        usuario: 'usuarioEjemplo', // Aquí debes pasar el usuario real
        camaronera: codCamaronera,
        anio: anio,
        piscina: '',
        ciclo: '',
        fecha: '2024-09-16',
        codform: int.parse(codParametro),
      );

      // Procesa la respuesta
      List<Registro> registrosNuevos =
          response.map<Registro>((item) => Registro.fromMap(item)).toList();

      // Inserta los nuevos registros en SQLite
      for (var registro in registrosNuevos) {
        await _dbHelper.insertRegistro(registro);
      }

      // Obtén todos los registros de la BD local
      _registros = await _dbHelper.getRegistros();
    } catch (e) {
      // Manejo de error
      print('Error cargando registros: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRegistro(int secRegistro) async {
    await _dbHelper.deleteRegistro(secRegistro);
    _registros = await _dbHelper.getRegistros();
    notifyListeners();
  }

  Future<void> updateRegistro(Registro registro) async {
    await _dbHelper.updateRegistro(registro);
    _registros = await _dbHelper.getRegistros();
    notifyListeners();
  }
}
