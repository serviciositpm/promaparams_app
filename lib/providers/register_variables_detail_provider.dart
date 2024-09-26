import 'package:flutter/material.dart';
import 'package:promaparams_app/helpers/helpers.dart';
import 'package:promaparams_app/models/models.dart';

class DetalleRegistrosProvider extends ChangeNotifier {
  List<DetalleRegistro> _detalles = [];
  final DBHelper _dbHelper = DBHelper();

  List<DetalleRegistro> get detalles => _detalles;

  // Método para insertar registros y sus detalles
  Future<void> insertarRegistrosDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    await _dbHelper.insertarRegistrosDetalle(registro, detalles);
    _detalles.addAll(detalles);
    notifyListeners(); // Notificar a toda la app sobre los cambios
  }

  // Método para actualizar registros y sus detalles
  Future<void> updateRegistroDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    await _dbHelper.updateRegistroDetalle(registro, detalles);
    // Actualizar la lista local y notificar cambios
    _detalles = _detalles.map((detalle) {
      if (detalle.secRegistro == registro.secRegistro) {
        return detalles.firstWhere((d) => d.codVariable == detalle.codVariable,
            orElse: () => detalle);
      }
      return detalle;
    }).toList();
    notifyListeners();
  }

  // Método para eliminar registros y sus detalles
  Future<void> deleteRegistroDetalle(
      int secRegistro, String codVariable, int codFormParametro) async {
    await _dbHelper.deleteRegistroDetalle(
        secRegistro, codVariable, codFormParametro);
    // Eliminar el detalle de la lista local
    _detalles.removeWhere((detalle) =>
        detalle.secRegistro == secRegistro &&
        detalle.codVariable == codVariable &&
        detalle.codFormParametro == codFormParametro);
    notifyListeners();
  }

  // Método para obtener detalles por secRegistro
  Future<void> getDetallesPorSecRegistro(int secRegistro) async {
    _detalles = await _dbHelper.getDetallesPorSecRegistro(secRegistro);
    notifyListeners();
  }

  // Método para obtener detalles por Id Cabecera
  Future<void> getDetallesPorId(int id) async {
    _detalles = await _dbHelper.getDetallesPorId(id);
    notifyListeners();
  }

  // Método para obtener detalles por codVariable
  Future<void> getDetallesPorCodVariable(String codVariable) async {
    _detalles = await _dbHelper.getDetallesPorCodVariable(codVariable);
    notifyListeners();
  }

  // Método para reiniciar la lista de detalles
  void resetDetalles() {
    _detalles = [];
    notifyListeners();
  }
}
