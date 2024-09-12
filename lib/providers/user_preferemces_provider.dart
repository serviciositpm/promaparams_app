import 'package:flutter/material.dart';
import 'package:promaparams_app/utils/utils.dart';

class UserProvider with ChangeNotifier {
  String? _usuario;
  String? get usuario => _usuario;

  Future<void> loadUser() async {
    final userPreferences = UserPreferences();
    final usuarioObtenido = await userPreferences.getUser();

    if (usuarioObtenido != null) {
      _usuario = usuarioObtenido;
      notifyListeners();
    } else {
      throw Exception('Usuario no encontrado en las preferencias');
    }
  }
}
