class DetalleRegistro {
  final int? secuencia;
  final int id;
  final int secRegistro;
  final String codCamaronera;
  final String descCamaronera;
  final int codFormParametro;
  final String descFormParametro;
  final String fecRegistro;
  final String estadoRegistro;
  final int anio;
  final String piscina;
  final String despiscina;
  final String ciclo;
  final String codVariable;
  final String tipoDato;
  final String nombre;
  final String valorVariable;
  final int sincronizado;

  DetalleRegistro({
    this.secuencia,
    required this.id,
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
    required this.codVariable,
    required this.tipoDato,
    required this.nombre,
    required this.valorVariable,
    required this.sincronizado,
  });

  // Convertir un DetalleRegistro a un Map (para usar en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'secuencia': secuencia,
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
      'codVariable': codVariable,
      'tipoDato': tipoDato,
      'nombre': nombre,
      'valorVariable': valorVariable,
      'sincronizado': sincronizado,
    };
  }

  // Convertir un Map a un DetalleRegistro (para leer desde SQLite)
  factory DetalleRegistro.fromMap(Map<String, dynamic> map) {
    return DetalleRegistro(
      secuencia: map['secuencia'],
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
      codVariable: map['codVariable'],
      tipoDato: map['tipoDato'],
      nombre: map['nombre'],
      valorVariable: map['valorVariable'],
      sincronizado: map['sincronizado'],
      /* secuencia: map['secuencia'] ?? 0, // Valor predeterminado si es nulo
      id: map['id'] ?? 0,
      secRegistro: map['secRegistro'] ?? 0,
      codCamaronera: map['codCamaronera'] ?? '',
      descCamaronera: map['descCamaronera'] ?? '',
      codFormParametro: map['codFormParametro'] ?? 0,
      descFormParametro: map['descFormParametro'] ?? '',
      fecRegistro: map['fecRegistro'] ?? '',
      estadoRegistro: map['estadoRegistro'] ?? '',
      anio: map['anio'] ?? 0,
      piscina: map['piscina'] ?? '',
      despiscina: map['despiscina'] ?? '',
      ciclo: map['ciclo'] ?? '',
      codVariable: map['codVariable'] ?? '',
      tipoDato: map['tipoDato'] ?? '',
      nombre: map['nombre'] ?? '',
      valorVariable: map['valorVariable'] ?? '',
      sincronizado: map['sincronizado'] ?? 0, */
    );
  }
}
