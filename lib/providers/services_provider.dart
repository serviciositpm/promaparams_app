import 'package:promaparams_app/services/services.dart';
import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  final services = DataGuiasRegServices();
  llamarApiGuiasRegistradas(String tipo, String opcion) async {
    await services.loadGuiasRegistradas(tipo, opcion);
    notifyListeners();
  }
}
