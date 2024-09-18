import 'package:promaparams_app/providers/providers.dart';
/* import 'package:promaparams_app/models/models.dart'; */
import 'package:flutter/material.dart';

class RegisteredGuiasProvider extends ChangeNotifier {
  List<RegisteredGuias> registrados = [];
  /* List<BinesGrAsigModel> binAsignados = []; */

  late RegisteredGuias guiaSeleccionadaReg;
  Future<RegisteredGuias> nuevaGuiaRegistrada(
      String tipoproceso,
      String nroguia,
      String fechaguia,
      double kg,
      String piscina,
      int cantescaneada,
      int sincronizado,
      int activo) async {
    final nuevaGuiaReg = RegisteredGuias(
        tipoproceso: tipoproceso,
        nroguia: nroguia,
        fechaguia: fechaguia,
        kg: kg,
        piscina: piscina,
        cantescaneada: cantescaneada,
        activo: activo,
        sincronizado: sincronizado);
    nuevaGuiaReg.nroguia = await DBProvider.db.insertGuiasReg(nuevaGuiaReg);
    registrados.add(nuevaGuiaReg);
    notifyListeners();
    return nuevaGuiaReg;
  }

  cargarGrRegistradas(String tipoproceso) async {
    final registrados = await DBProvider.db.consultaGrReg(tipoproceso);
    this.registrados = [...?registrados];
    notifyListeners();
  }

  borrarGuiasRegistradas(String tipoproceso) async {
    await DBProvider.db.borrarGuiasReg(tipoproceso);
    cargarGrRegistradas(tipoproceso);
  }

  borrarRegGuiasxGuia(String tipoproceso, String nroguia) async {
    await DBProvider.db.borrarRegGuiasDB(tipoproceso, nroguia);
    cargarGrRegistradas(tipoproceso);
  }

  insertDatManual(
      String tipoproceso,
      String noguia,
      String fechaguia,
      double kg,
      String piscina,
      int cantescaneada,
      int sincronizado,
      int activo) {
    DBProvider.db.insertGuiasRegMan(tipoproceso, noguia, fechaguia, kg, piscina,
        cantescaneada, sincronizado, activo);
    cargarGrRegistradas(tipoproceso);
    notifyListeners();
    return noguia;
  }
}
