import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class PoolProvider with ChangeNotifier {
  final PoolServices _piscinasService = PoolServices();
  List<Map<String, String>> _piscinas = [];
  String? _selectedPiscina;
  bool _isLoading = false;

  List<Map<String, String>> get piscinas => _piscinas;
  String? get selectedPiscina => _selectedPiscina;
  bool get isLoading => _isLoading;

  Future<void> fetchPiscinas({
    required String usuario,
    required String camaronera,
    required String anio,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _piscinas = await _piscinasService.getPools(
        usuario: usuario,
        camaronera: camaronera,
        anio: anio,
      );
    } catch (e) {
      _piscinas = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setPiscina(String piscina) {
    _selectedPiscina = piscina;
    notifyListeners();
  }
}
