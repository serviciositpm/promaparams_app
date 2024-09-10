// To parse this JSON data, do
//
//     final registeredGuias = registeredGuiasFromJson(jsonString);

import 'dart:convert';

RegisteredGuias registeredGuiasFromJson(String str) =>
    RegisteredGuias.fromJson(json.decode(str));

String registeredGuiasToJson(RegisteredGuias data) =>
    json.encode(data.toJson());

class RegisteredGuias {
  RegisteredGuias({
    required this.tipoproceso,
    required this.nroguia,
    required this.fechaguia,
    required this.kg,
    required this.piscina,
    required this.cantescaneada,
    required this.activo,
    required this.sincronizado,
  });

  String tipoproceso;
  String nroguia;
  String fechaguia;
  double kg;
  String piscina;
  int cantescaneada;
  int activo;
  int sincronizado;

  factory RegisteredGuias.fromJson(Map<String, dynamic> json) =>
      RegisteredGuias(
        tipoproceso: json["tipoproceso"],
        nroguia: json["nroguia"],
        fechaguia: json["fechaguia"],
        kg: json["kg"].toDouble(),
        piscina: json["piscina"],
        cantescaneada: json["cantescaneada"],
        activo: json["activo"],
        sincronizado: json["sincronizado"],
      );

  Map<String, dynamic> toJson() => {
        "tipoproceso": tipoproceso,
        "nroguia": nroguia,
        "fechaguia": fechaguia,
        "kg": kg,
        "piscina": piscina,
        "cantescaneada": cantescaneada,
        "activo": activo,
        "sincronizado": sincronizado,
      };
  RegisteredGuias copy() => RegisteredGuias(
      tipoproceso: tipoproceso,
      nroguia: nroguia,
      fechaguia: fechaguia,
      kg: kg,
      piscina: piscina,
      cantescaneada: cantescaneada,
      activo: activo,
      sincronizado: sincronizado);
}
