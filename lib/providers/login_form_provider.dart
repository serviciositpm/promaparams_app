import 'package:flutter/material.dart';

class LoginFormaProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;
  String cedula = '';
  String nombres = '';
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }
}
