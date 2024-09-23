import 'package:flutter/material.dart';

class FormVariableProvider with ChangeNotifier {
  String? _errorMessage;
  bool _isValid = false;

  String? get errorMessage => _errorMessage;
  bool get isValid => _isValid;

  void validate(String value, String tipoDato) {
    if (tipoDato == 'Número') {
      if (!RegExp(r'^\d+$').hasMatch(value)) {
        _errorMessage = 'Solo se permiten números';
        _isValid = false;
      } else {
        _errorMessage = null;
        _isValid = true;
      }
    } else if (tipoDato == 'Texto') {
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _errorMessage = 'Solo se permiten letras';
        _isValid = false;
      } else {
        _errorMessage = null;
        _isValid = true;
      }
    } else {
      if (value.isEmpty) {
        _errorMessage = 'El campo no puede estar vacío';
        _isValid = false;
      } else {
        _errorMessage = null;
        _isValid = true;
      }
    }
    notifyListeners();
  }

  void reset() {
    _errorMessage = null;
    _isValid = false;
    notifyListeners();
  }
}
