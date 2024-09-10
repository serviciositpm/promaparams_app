// To parse this JSON data, do
//
//     final assiggrModel = assiggrModelFromJson(jsonString);

import 'dart:convert';

AssiggrModel assiggrModelFromJson(String str) =>
    AssiggrModel.fromJson(json.decode(str));

String assiggrModelToJson(AssiggrModel data) => json.encode(data.toJson());

class AssiggrModel {
  AssiggrModel({
    required this.tipoproceso,
    required this.nroguia,
    required this.fecha,
    required this.kg,
    required this.piscina,
    required this.cant,
    required this.placa,
    required this.registratiempo,
    required this.cedula,
    required this.sincronizado,
    required this.activo,
    required this.fechahorareg,
  });

  String tipoproceso;
  String nroguia;
  String fecha;
  double kg;
  String piscina;
  int cant;
  String placa;
  String registratiempo;
  String cedula;
  int sincronizado;
  int activo;
  String fechahorareg;

  Map<String, dynamic> toJson() => {
        "tipoproceso": tipoproceso,
        "nroguia": nroguia,
        "fecha": fecha,
        "kg": kg,
        "piscina": piscina,
        "cant": cant,
        "placa": placa,
        "registratiempo": registratiempo,
        "cedula": cedula,
        "sincronizado": sincronizado,
        "activo": activo,
        "fechahorareg": fechahorareg,
      };
  factory AssiggrModel.fromJson(Map<String, dynamic> json) => AssiggrModel(
        tipoproceso: json["tipoproceso"],
        nroguia: json["nroguia"],
        fecha: json["fecha"],
        kg: json["kg"].toDouble(),
        piscina: json["piscina"],
        cant: json["cant"],
        placa: json["placa"],
        registratiempo: json["registratiempo"],
        cedula: json["cedula"],
        sincronizado: json["sincronizado"],
        activo: json["activo"],
        fechahorareg: json["fechahorareg"],
      );
  @override
  String toString() {
    return 'AssiggrModel{tipoproceso:$tipoproceso,nroGuia :$nroguia,fecha:$fecha,kg:$kg,piscina:$piscina,cant:$cant,sincronizado:$sincronizado,activo:$activo}';
  }

  AssiggrModel copy() => AssiggrModel(
      tipoproceso: tipoproceso,
      nroguia: nroguia,
      fecha: fecha,
      kg: kg,
      piscina: piscina,
      cant: cant,
      placa: placa,
      registratiempo: registratiempo,
      cedula: cedula,
      sincronizado: sincronizado,
      activo: activo,
      fechahorareg: fechahorareg);
}
