// To parse this JSON data, do
//
//     final binesGrAsigModel = binesGrAsigModelFromJson(jsonString);

import 'dart:convert';

BinesGrAsigModel binesGrAsigModelFromJson(String str) =>
    BinesGrAsigModel.fromJson(json.decode(str));

String binesGrAsigModelToJson(BinesGrAsigModel data) =>
    json.encode(data.toJson());

class BinesGrAsigModel {
  BinesGrAsigModel({
    required this.nroguia,
    required this.nrobin,
    required this.fechahora,
    required this.sincronizado,
    required this.activo,
  });

  String nroguia;
  int nrobin;
  String fechahora;
  int sincronizado;
  int activo;

  factory BinesGrAsigModel.fromJson(Map<String, dynamic> json) =>
      BinesGrAsigModel(
        nroguia: json["nroguia"],
        nrobin: json["nrobin"],
        fechahora: json["fechahora"],
        sincronizado: json["sincronizado"],
        activo: json["activo"],
      );

  Map<String, dynamic> toJson() => {
        "nroguia": nroguia,
        "nrobin": nrobin,
        "fechahora": fechahora,
        "sincronizado": sincronizado,
        "activo": activo,
      };
}
