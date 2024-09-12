import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class CamaronerasProvider with ChangeNotifier {
  List<Map<String, dynamic>> _camaroneras = [];
  List<Map<String, dynamic>> _parametros = [];
  bool _isLoadingCamaroneras = true;
  bool _isLoadingParametros = false;

  List<Map<String, dynamic>> get camaroneras => _camaroneras;
  List<Map<String, dynamic>> get parametros => _parametros;
  bool get isLoadingCamaroneras => _isLoadingCamaroneras;
  bool get isLoadingParametros => _isLoadingParametros;

  Future<void> loadCamaroneras(String usuario) async {
    final apiService = ApiFarmService();
    _isLoadingCamaroneras = true;
    notifyListeners();

    try {
      _camaroneras = await apiService.obtenerCamaroneras(usuario) ?? [];
    } catch (e) {
      throw Exception('Error al cargar camaroneras: ${e.toString()}');
    } finally {
      _isLoadingCamaroneras = false;
      notifyListeners();
    }
  }

  Future<void> loadParametros(String usuario, String camaronera) async {
    final apiService = ApiFarmService();
    _isLoadingParametros = true;
    notifyListeners();

    try {
      _parametros =
          await apiService.obtenerParametros(usuario, camaronera) ?? [];
    } catch (e) {
      throw Exception('Error al cargar parámetros: ${e.toString()}');
    } finally {
      _isLoadingParametros = false;
      notifyListeners();
    }
  }
}
