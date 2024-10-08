class Registro {
  int? id;
  int secRegistro;
  String codCamaronera;
  String descCamaronera;
  int codFormParametro;
  String descFormParametro;
  String fecRegistro;
  String estadoRegistro;
  int anio;
  String piscina;
  String despiscina;
  String ciclo;
  int sincronizado;

  Registro({
    this.id,
    required this.secRegistro,
    required this.codCamaronera,
    required this.descCamaronera,
    required this.codFormParametro,
    required this.descFormParametro,
    required this.fecRegistro,
    required this.estadoRegistro,
    required this.anio,
    required this.piscina,
    required this.despiscina,
    required this.ciclo,
    required this.sincronizado,
  });

  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      secRegistro: map['secRegistro'],
      codCamaronera: map['codCamaronera'],
      descCamaronera: map['descCamaronera'],
      codFormParametro: map['codFormParametro'],
      descFormParametro: map['descFormParametro'],
      fecRegistro: map['fecRegistro'],
      estadoRegistro: map['estadoRegistro'],
      anio: map['anio'],
      piscina: map['piscina'],
      despiscina: map['despiscina'],
      ciclo: map['ciclo'],
      sincronizado: map['sincronizado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secRegistro': secRegistro,
      'codCamaronera': codCamaronera,
      'descCamaronera': descCamaronera,
      'codFormParametro': codFormParametro,
      'descFormParametro': descFormParametro,
      'fecRegistro': fecRegistro,
      'estadoRegistro': estadoRegistro,
      'anio': anio,
      'piscina': piscina,
      'despiscina': despiscina,
      'ciclo': ciclo,
      'sincronizado': sincronizado,
    };
  }
}
