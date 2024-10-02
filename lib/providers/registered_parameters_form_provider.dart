import 'package:flutter/material.dart';
import 'package:promaparams_app/models/models.dart';
import 'package:promaparams_app/services/services.dart';
import 'package:promaparams_app/helpers/helpers.dart';

class RegisteredParameteresProvider with ChangeNotifier {
  List<Registro> _registros = [];
  bool isLoading = false;
  final ApiServiceRegisteredParams _apiService = ApiServiceRegisteredParams();
  final DBHelper _dbHelper = DBHelper();

  List<Registro> get registros => _registros;

  Future<void> loadRegistros(
    String codCamaronera,
    String codParametro,
    int anio,
  ) async {
    isLoading = true;
    notifyListeners();
    // Elimina los registros locales antes de consumir el API
    await _dbHelper.deleteRegistroPorCamaroneraYParametro(
        codCamaronera, int.parse(codParametro));
    try {
      // Llama al API
      final response = await _apiService.obtenerRegistrosParametros(
          opcion: 'CRP',
          usuario: 'breyes', // Aquí debes pasar el usuario real
          camaronera: codCamaronera,
          anio: anio,
          piscina: '',
          ciclo: '',
          fecha: '2024-09-01',
          codform: int.parse(codParametro));
      // Verifica si el API devuelve "No hay datos registrados"
      if (response.isNotEmpty && response.first['codMsg'] == 300) {
        // ignore: avoid_print
        print(
            'Resultado Api >> No hay datos registrados para los parámetros proporcionados.');
        isLoading = false;
        _registros = await _dbHelper.getRegistrosPorCamaroneraYParametro(
            codCamaronera, int.parse(codParametro));
        notifyListeners();
        return; // Sale del método sin proceder con la inserción
      }
      // Procesa la respuesta
      List<Registro> registrosNuevos =
          response.map<Registro>((item) => Registro.fromMap(item)).toList();

      // Inserta los nuevos registros en SQLite
      for (var registro in registrosNuevos) {
        await _dbHelper.insertRegistroPorCamaroneraYParametro(
            registro, codCamaronera, int.parse(codParametro));
      }
      // Obtén todos los registros de la BD local
      _registros = await _dbHelper.getRegistrosPorCamaroneraYParametro(
          codCamaronera, int.parse(codParametro));
    } catch (e) {
      // Manejo de error
      // ignore: avoid_print
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

  Future<void> deleteRegistroPorCamaroneraYParametro(
      String codCamaronera, String codParametro) async {
    await _dbHelper.deleteRegistroPorCamaroneraYParametro(
        codCamaronera, int.parse(codParametro));
    _registros = await _dbHelper.getRegistrosPorCamaroneraYParametro(
        codCamaronera, int.parse(codParametro));
    notifyListeners();
  }

  Future<void> updateRegistroPorCamaroneraYParametro(
      Registro registro, String codCamaronera, String codParametro) async {
    await _dbHelper.updateRegistroPorCamaroneraYParametro(
        registro, codCamaronera, int.parse(codParametro));
    _registros = await _dbHelper.getRegistrosPorCamaroneraYParametro(
        codCamaronera, int.parse(codParametro));
    notifyListeners();
  }
}
