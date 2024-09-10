import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';

class ServicesProviderCMP extends ChangeNotifier {
  final services = DataGuiasRegServicesCMP();
  llamarApiGuiasRegistradas(
      String nroguia, String opcion, String usuario) async {
    await services.loadGuiasRegistradas(nroguia, opcion, usuario);
    notifyListeners();
  }
}
