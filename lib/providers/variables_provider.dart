import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class VariablesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _variables = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get variables => _variables;
  bool get isLoading => _isLoading;

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
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener variables: $e');
      _variables = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para limpiar las variables
  void clearVariables() {
    _variables = [];
    notifyListeners();
  }
}
