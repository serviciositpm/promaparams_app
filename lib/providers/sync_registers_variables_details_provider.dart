import 'package:flutter/material.dart';
import 'package:promaparams_app/services/services.dart';
import 'package:promaparams_app/helpers/helpers.dart'; // Importa el DBHelper

class SyncVariablesFormDetailsProvider with ChangeNotifier {
  final SyncVariablesFormDetailsService _syncService =
      SyncVariablesFormDetailsService();
  final DBHelper _dbHelper =
      DBHelper(); // Instancia del DBHelper para manejar la BD local

  bool _isSyncing = false;
  String _syncStatus =
      ''; // Nuevo estado para el resultado de la sincronización

  bool get isSyncing => _isSyncing;
  String get syncStatus =>
      _syncStatus; // Getter para el estado de sincronización

  Future<void> syncData(List<Map<String, dynamic>> registros) async {
    _isSyncing = true;
    _syncStatus = ''; // Reiniciar el estado antes de iniciar la sincronización
    notifyListeners();

    try {
      // Llamar al servicio para sincronizar
      final isSuccess = await _syncService.syncData(registros);

      if (isSuccess) {
        // Recorrer los registros sincronizados y marcar como sincronizados en la base de datos local
        for (var registro in registros) {
          int secRegistroLocal =
              registro['id']; // Suponiendo que el secRegistro viene en el JSON
          await _dbHelper.marcarComoSincronizado(
              secRegistroLocal); // Marcar como sincronizado en la BD local
        }

        _syncStatus = 'Sincronización exitosa'; // Actualiza el estado al éxito
      } else {
        _syncStatus = 'Sincronización fallida'; // Actualiza el estado al fallo
      }
    } catch (e) {
      _syncStatus =
          'Error al sincronizar: $e'; // Actualiza el estado al fallo con el error
    } finally {
      _isSyncing = false;
      notifyListeners(); // Notificar cambios
    }
  }
}
