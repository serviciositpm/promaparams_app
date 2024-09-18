import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/services/services.dart';
import 'package:flutter/material.dart';

class RegisteredBinGuiasProvider extends ChangeNotifier {
  List<RegisteredBinGuias> binAsignadosReg = [];
  int cantescaneados = 0;
  int actualizado = 0;
  Future<RegisteredBinGuias> nuevaGuiaBinAsignadoReg(
      String tipoproceso,
      String nroguia,
      int nrobin,
      String fechahoraesc,
      int sincronizado,
      int activo) async {
    final nuevoBinGuiaReg = RegisteredBinGuias(
        tipoproceso: tipoproceso,
        nroguia: nroguia,
        nrobin: nrobin,
        fechahoraesc: fechahoraesc,
        activo: activo,
        sincronizado: sincronizado);

    nuevoBinGuiaReg.nrobin =
        await DBProvider.db.insertBinGrReg(nuevoBinGuiaReg);
    binAsignadosReg.add(nuevoBinGuiaReg);
    notifyListeners();
    return nuevoBinGuiaReg;
  }

  cargarBinAsignadasReg(String nroguia, String tipoproceso) async {
    final binAsignadosReg =
        await DBProvider.db.consultaBinAsignadasReg(nroguia, tipoproceso);
    this.binAsignadosReg = [...?binAsignadosReg];
    catidadBinesEscaneadosReg(nroguia, tipoproceso);
    notifyListeners();
  }

  borrarBinesGuiaReg(String nroguia, String tipoproceso) async {
    await DBProvider.db.borrarBinesGuias(nroguia);
    cargarBinAsignadasReg(nroguia, tipoproceso);
  }

  borrarBinGuiaReg(String nroguia, int nrobin, String tipoproceso) async {
    await DBProvider.db.borrarBinEscaneadReg(nroguia, nrobin, tipoproceso);
    cargarBinAsignadasReg(nroguia, tipoproceso);
  }

  catidadBinesEscaneadosReg(String nroguia, String tipoproceso) async {
    final cantescaneados =
        await DBProvider.db.cantidadBinesEscaneadosReg(nroguia, tipoproceso);
    this.cantescaneados = cantescaneados;
    notifyListeners();
  }

  updateBinesSincronizadosReg(String nroguia, int activo, int sincronizado,
      int nrobin, String tipoproceso) async {
    final actualizado = await DBProvider.db
        .actSincGrBinesReg(nroguia, activo, sincronizado, nrobin, tipoproceso);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoproceso);
    notifyListeners();
  }

  //Recibo los datos y los envio uno por uno
  updateGuiaBinReg(RegisteredBinGuiasProvider datosGuiasReg, String opcion,
      String numGuia, String tipoProceso, RegisteredGuiasProvider guiasReg) {
    DateTime now = DateTime.now();
    final String fecha = now.toString();
    String sigProceso = '';

    for (int index = 0; index < datosGuiasReg.binAsignadosReg.length; index++) {
      final String nroguia = datosGuiasReg.binAsignadosReg[index].nroguia;
      final String procesoEnv =
          datosGuiasReg.binAsignadosReg[index].tipoproceso;
      if (nroguia == numGuia && tipoProceso == procesoEnv) {
        final int nrobin = datosGuiasReg.binAsignadosReg[index].nrobin;
        final String tipoproceso =
            datosGuiasReg.binAsignadosReg[index].tipoproceso;
        updateFechaBinReg(nroguia, nrobin, tipoproceso, fecha);

        //-------------------------
        //Actualizo el estado a inactivo para q no se pueda modificar ya
        //-------------------------
        updateBinesSincronizadosReg(nroguia, 0, 0, nrobin, tipoproceso);
      }
    }
    //--------------------
    //Actualiza el estado de la cabecera
    //--------------------
    updateGuiasReg(numGuia, tipoProceso, 1, 0);

    //--------------------
    //Invocacion de Funcion para insertar el siguiente proceso
    //Funcion para el siguiente proceso
    //--------------------
    switch (tipoProceso) {
      case 'RSP':
        sigProceso = 'RLG';
        break;
      case 'RLG':
        sigProceso = 'RCB';
        break;
      case 'RCB':
        sigProceso = 'RSG';
        break;
      case 'RSG':
        sigProceso = 'RLP';
        break;
      case 'RLP':
        sigProceso = 'RLR';
        break;
      case 'RLR':
        sigProceso = 'RRR';
    }
    insertaNuevoProc(guiasReg, datosGuiasReg, sigProceso, numGuia, tipoProceso);

    //--------------------
    //Invocacion de funcion que consume el api para insertar informaciòn
    //--------------------
    consumeApiReg(opcion, numGuia, fecha, tipoProceso);
  }

  insertaNuevoProc(
      RegisteredGuiasProvider guiasReg,
      RegisteredBinGuiasProvider datosGuiasReg,
      String sigProceso,
      String numGuia,
      String tipoProcesoEnv) async {
    //--------------------
    //Recorro el modelo de datos de la cabecera
    //--------------------
    for (int index = 0; index < guiasReg.registrados.length; index++) {
      final String nroguia = guiasReg.registrados[index].nroguia;
      final String procesoEnv = guiasReg.registrados[index].tipoproceso;
      if (nroguia == numGuia && tipoProcesoEnv == procesoEnv) {
        final fechaguia = guiasReg.registrados[index].fechaguia;
        final double kg = guiasReg.registrados[index].kg;
        final String piscina = guiasReg.registrados[index].piscina;
        final int cantescaneada = guiasReg.registrados[index].cantescaneada;
        // ignore: unused_local_variable
        final guiasRec = await RegisteredGuiasProvider().nuevaGuiaRegistrada(
            sigProceso, nroguia, fechaguia, kg, piscina, cantescaneada, 0, 1);
        //Leera e Insertara el detalle de los bines
        for (int index = 0;
            index < datosGuiasReg.binAsignadosReg.length;
            index++) {
          final int nrobin = datosGuiasReg.binAsignadosReg[index].nrobin;
          final String guia = datosGuiasReg.binAsignadosReg[index].nroguia;
          final String tproces =
              datosGuiasReg.binAsignadosReg[index].tipoproceso;
          if (numGuia == guia && tproces == tipoProcesoEnv) {
            // ignore: unused_local_variable
            final guiasBinReg =
                nuevaGuiaBinAsignadoReg(sigProceso, nroguia, nrobin, '', 0, 1);
          }
        }
      }
    }
    RegisteredGuiasProvider().cargarGrRegistradas(tipoProcesoEnv);
    cargarBinAsignadasReg(numGuia, tipoProcesoEnv);
    notifyListeners();
  }

  //-----------------------------------
  //Envio todo lo que esta en la bd a que a q sea insertado en la base de sipe
  //-----------------------------------
  envioDatosApi(RegisteredBinGuiasProvider datosGuiasReg, String opcion,
      String tipoProceso, RegisteredGuiasProvider guiasReg) {
    //------------------------------
    //Recorro la matriz de las guia
    //------------------------------
    for (int indice = 0;
        indice <
            datosGuiasReg.binAsignadosReg
                .length /* &&
            flag ==
                0 */ /* &&
            tipoProceso == datosGuiasReg.binAsignadosReg[indice].tipoproceso &&
            datosGuiasReg.binAsignadosReg[indice].sincronizado == 0 &&
            datosGuiasReg.binAsignadosReg[indice].fechahoraesc.isNotEmpty */
        ;
        indice++) {
      /* if (tipoProceso == datosGuiasReg.binAsignadosReg[indice].tipoproceso &&
          datosGuiasReg.binAsignadosReg[indice].sincronizado == 0 &&
          datosGuiasReg.binAsignadosReg[indice].fechahoraesc.isNotEmpty) {
        final String nroguia = datosGuiasReg.binAsignadosReg[indice].nroguia;
        final String fecha = datosGuiasReg.binAsignadosReg[indice].fechahoraesc;
        final String tipoproceso =
            datosGuiasReg.binAsignadosReg[indice].tipoproceso;
        const String relacionTabla = 'DET';
        final int nrobin = datosGuiasReg.binAsignadosReg[indice].nrobin;
        print('Entro al Future Opcion $opcion , Tipo Proceso $tipoProceso');
        //envio cabeceras

        if (tipoproceso == 'RSP' ||
            tipoproceso == 'RLG' ||
            tipoproceso == 'RSG' ||
            tipoproceso == 'RLP' ||
            tipoproceso == 'RLR') {
          DataGuiasRegServices().sincronizaGuiasBinRegBD(
              opcion, nroguia, fecha, tipoproceso, relacionTabla, nrobin);
          flag = 1;
        } else {
          DataGuiasRegServices().sincronizaGuiasBinRegBD(
              opcion, nroguia, fecha, tipoproceso, relacionTabla, nrobin);
          flag = 0;
        }
      } */

      /* for (int index = 0; index < datosGuiasReg.binAsignadosReg.length; index++) {
      final String nroguia = datosGuiasReg.binAsignadosReg[index].nroguia;
      final String procesoEnv =
          datosGuiasReg.binAsignadosReg[index].tipoproceso;

      
      
      
      if (nroguia == numGuia && tipoProceso == procesoEnv) {
        final int nrobin = datosGuiasReg.binAsignadosReg[index].nrobin;

        /* final String tipoproceso =
            datosGuiasReg.binAsignadosReg[index].tipoproceso;
        updateFechaBinReg(nroguia, nrobin, tipoproceso, fecha); */

        //-------------------------
        //Actualizo el estado a inactivo para q no se pueda modificar ya
        //-------------------------
        /* updateBinesSincronizadosReg(nroguia, 0, 0, nrobin, tipoproceso); */
      }
    } */
    }
  }

  //---------------------------
  //Envia los datos al api para la bd
  //---------------------------
  consumeAPiEnvReg(String opcion, String nroguia, String fecha,
      String tipoProceso, String relacionTabla, int nrobin) async {
    final services = DataGuiasRegServices();
    final actualizado = await services.sincronizaGuiasBinRegBD(
        opcion, nroguia, fecha, tipoProceso, relacionTabla, nrobin);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoProceso);
    notifyListeners();
  }

  //---------------------------
  //Envia los datos al api para la bd
  //---------------------------
  consumeApiReg(
      String opcion, String nroguia, String fecha, String tipoProceso) async {
    final services = DataGuiasRegServices();
    final actualizado =
        await services.updateRegGuiasBD(opcion, nroguia, fecha, tipoProceso);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoProceso);
    notifyListeners();
  }

  actualizarEstadosRegBin(
      String nroguia, String tipoproceso, int activo, int sincronizado) async {
    final actualizado = await DBProvider.db
        .actEstadoBinesReg(nroguia, activo, sincronizado, tipoproceso);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoproceso);
    notifyListeners();
  }

  //Actualiza el estado de la tabla de guias registradas
  updateGuiasReg(
      String nroguia, String tipoproceso, int activo, int sincronizado) async {
    final actualizado = await DBProvider.db
        .actSincGrReg(nroguia, activo, sincronizado, tipoproceso);
    this.actualizado = actualizado;
    RegisteredGuiasProvider().cargarGrRegistradas(tipoproceso);
    cargarBinAsignadasReg(nroguia, tipoproceso);
    notifyListeners();
  }

  updateFechaBinReg(
      String nroguia, int bin, String tipoproceso, String fecha) async {
    final actualizado =
        await DBProvider.db.actBinReg(nroguia, bin, tipoproceso, fecha);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoproceso);
    notifyListeners();
  }

  updateEstadoGuiaReg(String nroguia, int activo, String tipoproceso) async {
    final actualizado =
        await DBProvider.db.actGrEstadoReg(nroguia, activo, tipoproceso);
    this.actualizado = actualizado;
    cargarBinAsignadasReg(nroguia, tipoproceso);
    notifyListeners();
  }
}
