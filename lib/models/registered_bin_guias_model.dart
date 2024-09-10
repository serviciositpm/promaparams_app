// To parse this JSON data, do
//
//     final registeredBinGuias = registeredBinGuiasFromJson(jsonString);

import 'dart:convert';

RegisteredBinGuias registeredBinGuiasFromJson(String str) =>
    RegisteredBinGuias.fromJson(json.decode(str));

String registeredBinGuiasToJson(RegisteredBinGuias data) =>
    json.encode(data.toJson());

class RegisteredBinGuias {
  RegisteredBinGuias({
    required this.tipoproceso,
    required this.nroguia,
    required this.nrobin,
    required this.fechahoraesc,
    required this.activo,
    required this.sincronizado,
  });

  String tipoproceso;
  String nroguia;
  int nrobin;
  String fechahoraesc;
  int activo;
  int sincronizado;

  factory RegisteredBinGuias.fromJson(Map<String, dynamic> json) =>
      RegisteredBinGuias(
        tipoproceso: json["tipoproceso"],
        nroguia: json["nroguia"],
        nrobin: json["nrobin"],
        fechahoraesc: json["fechahoraesc"],
        activo: json["activo"],
        sincronizado: json["sincronizado"],
      );

  Map<String, dynamic> toJson() => {
        "tipoproceso": tipoproceso,
        "nroguia": nroguia,
        "nrobin": nrobin,
        "fechahoraesc": fechahoraesc,
        "activo": activo,
        "sincronizado": sincronizado,
      };
}
