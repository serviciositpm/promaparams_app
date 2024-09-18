import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class CiclesProvider with ChangeNotifier {
  final CiclesServices _ciclesService = CiclesServices();
  List<Map<String, String>> _ciclos = [];
  bool _isLoading = false;

  List<Map<String, String>> get ciclos => _ciclos;
  bool get isLoading => _isLoading;

  Future<void> fetchCiclos({
    required String usuario,
    required String camaronera,
    required String anio,
    required String piscina,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _ciclos = await _ciclesService.getCicles(
        usuario: usuario,
        camaronera: camaronera,
        anio: anio,
        piscina: piscina,
      );
    } catch (e) {
      _ciclos = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
