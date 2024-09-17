import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class CamaronerasProvider with ChangeNotifier {
  List<Map<String, dynamic>> _camaroneras = [];
  List<Map<String, dynamic>> _parametros = [];
  bool _isLoadingCamaroneras = true;
  bool _isLoadingParametros = false;

  String?
      _selectedCamaronera; // Nuevo campo para almacenar la camaronera seleccionada

  // Getters
  List<Map<String, dynamic>> get camaroneras => _camaroneras;
  List<Map<String, dynamic>> get parametros => _parametros;
  bool get isLoadingCamaroneras => _isLoadingCamaroneras;
  bool get isLoadingParametros => _isLoadingParametros;
  String? get selectedCamaronera =>
      _selectedCamaronera; // Getter para la camaronera seleccionada

  // Método para seleccionar la camaronera
  void setSelectedCamaronera(String? camaronera) {
    _selectedCamaronera = camaronera;
    notifyListeners();
  }

  // Cargar camaroneras
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

  // Cargar parámetros según la camaronera seleccionada
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
