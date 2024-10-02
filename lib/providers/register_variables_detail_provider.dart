import 'package:flutter/material.dart';
import 'package:promaparams_app/helpers/helpers.dart';
import 'package:promaparams_app/models/models.dart';

class DetalleRegistrosProvider extends ChangeNotifier {
  List<DetalleRegistro> _detalles = [];
  List<Registro> _cabecera = [];
  int? _saveIdRegistro;
  bool _isLoading = false;
  final DBHelper _dbHelper = DBHelper();

  List<DetalleRegistro> get detalles => _detalles;
  List<Registro> get cabecera => _cabecera;
  bool get isLoading => _isLoading;
  int? get savedIdRegistro => _saveIdRegistro;

  // Método para controlar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para insertar registros y sus detalles
  Future<int> insertarRegistrosDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    _setLoading(true); // Iniciar carga
    int registroId =
        await _dbHelper.insertarRegistrosDetalle(registro, detalles);
    _detalles.addAll(detalles);
    _setLoading(false); // Finalizar carga
    return registroId; // Notificar a toda la app sobre los cambios
  }

  // Método para actualizar registros y sus detalles
  Future<void> updateRegistroDetalle(
      Registro registro, List<DetalleRegistro> detalles) async {
    _setLoading(true); // Iniciar carga
    await _dbHelper.updateRegistroDetalle(registro, detalles);
    // Actualizar la lista local y notificar cambios
    _detalles = _detalles.map((detalle) {
      if (detalle.secRegistro == registro.secRegistro) {
        return detalles.firstWhere((d) => d.codVariable == detalle.codVariable,
            orElse: () => detalle);
      }
      return detalle;
    }).toList();
    _setLoading(false); // Finalizar carga
  }

  // Método para eliminar registros y sus detalles
  Future<void> deleteRegistroDetalle(
      int secRegistro, String codVariable, int codFormParametro) async {
    _setLoading(true); // Iniciar carga
    await _dbHelper.deleteRegistroDetalle(
        secRegistro, codVariable, codFormParametro);
    // Eliminar el detalle de la lista local
    _detalles.removeWhere((detalle) =>
        detalle.secRegistro == secRegistro &&
        detalle.codVariable == codVariable &&
        detalle.codFormParametro == codFormParametro);
    _setLoading(false); // Finalizar carga
  }

  // Método para obtener detalles por secRegistro
  Future<void> getDetallesPorSecRegistro(int secRegistro) async {
    _setLoading(true); // Iniciar carga
    _detalles = await _dbHelper.getDetallesPorSecRegistro(secRegistro);
    _setLoading(false); // Finalizar carga
  }

  // Método para obtener detalles por Id Cabecera
  Future<List<DetalleRegistro>> getDetallesPorId(int id) async {
    _setLoading(true); // Iniciar carga
    _detalles = await _dbHelper.getDetallesPorId(id);
    _setLoading(false); // Finalizar carga
    return _detalles;
  }

  // Método para obtener cabecera por Id
  Future<List<Registro>> getCabeceraPorId(int id) async {
    _setLoading(true); // Iniciar carga
    _cabecera = await _dbHelper.getCabeceraPorId(id);
    _setLoading(false); // Finalizar carga
    return _cabecera;
  }

  // Método para obtener detalles por codVariable
  Future<void> getDetallesPorCodVariable(String codVariable) async {
    _setLoading(true); // Iniciar carga
    _detalles = await _dbHelper.getDetallesPorCodVariable(codVariable);
    _setLoading(false); // Finalizar carga
  }

  // Método para reiniciar la lista de detalles
  void resetDetalles() {
    _detalles = [];
    notifyListeners();
  }

  void saveIdRegistro(int idRegistro) {
    _saveIdRegistro = idRegistro;
    notifyListeners();
  }
}
