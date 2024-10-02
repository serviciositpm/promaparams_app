import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';
import 'package:promaparams_app/helpers/helpers.dart';

class VariablesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _variables = [];
  bool _isLoading = false;
  String _tempValue =
      ''; // Almacena temporalmente el valor de la variable para editar
  final DBHelper _dbHelper = DBHelper();

  List<Map<String, dynamic>> get variables => _variables;
  bool get isLoading => _isLoading;
  String get tempValue => _tempValue;
  set tempValue(String value) {
    _tempValue = value;
    notifyListeners();
  }

  // Fetch y guardar las variables
  Future<void> fetchVariables({
    required String usuario,
    required String camaronera,
    required String anio,
    required String piscina,
    required String ciclo,
    required String fecha,
    required String codForm,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Consumir el API
      final apiVariablesServices = ApiVariablesServices();
      _variables = await apiVariablesServices.fetchVariables(
        usuario: usuario,
        camaronera: camaronera,
        anio: anio,
        piscina: piscina,
        ciclo: ciclo,
        fecha: fecha,
        codForm: codForm,
      );
      // Guardar en la base de datos local
      for (var variable in _variables) {
        await _dbHelper.insertVariable({
          'usuario': usuario,
          'codCamaronera': camaronera,
          'descCamaronera': variable['descCamaronera'],
          'codParametro': codForm,
          'descParametro': variable['descFormParametro'],
          'codVariable': variable['codVariable'],
          'tipoDato': variable['tipoDato'],
          'nombre': variable['nombre'],
          'valorVariable': variable['valorVariable'],
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener variables: $e');
      _variables = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Obtener variables desde la base de datos
  Future<void> loadVariablesFromDatabase() async {
    _isLoading = true;
    notifyListeners();

    try {
      final variablesFromDb = await _dbHelper.getVariables();
      _variables = variablesFromDb;
    } catch (e) {
      // ignore: avoid_print
      print('Error al cargar variables desde la base de datos: $e');
      _variables = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para limpiar las variables
  void clearVariables() async {
    _variables = [];
    await _dbHelper.deleteAllVariables();
    notifyListeners();
  }

  // Actualizar una variable en la base de datos
  Future<void> updateVariable({
    required String codParametro,
    required String codVariable,
    required String valorVariable,
  }) async {
    // ignore: avoid_print
    print('Variables Parametro => $codParametro');
    print('Variables Cod Variable => $codVariable');
    print('Variables Valor => $valorVariable');

    try {
      await _dbHelper.updateVariable({
        'codParametro': codParametro,
        'codVariable': codVariable,
        'valorVariable': valorVariable,
      });

      // Refrescar las variables cargadas desde la base de datos
      await loadVariablesFromDatabase();
    } catch (e) {
      // ignore: avoid_print
      print('Error al actualizar la variable: $e');
    }
  }
}
