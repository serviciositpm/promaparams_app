class DetalleRegistro {
  int secRegistro;
  int codParametro;
  int codVariable;
  String tipoDato;
  String nombreVariable;
  String valorVariable;

  DetalleRegistro({
    required this.secRegistro,
    required this.codParametro,
    required this.codVariable,
    required this.tipoDato,
    required this.nombreVariable,
    required this.valorVariable,
  });

  factory DetalleRegistro.fromMap(Map<String, dynamic> map) {
    return DetalleRegistro(
      secRegistro: map['secRegistro'],
      codParametro: map['codParametro'],
      codVariable: map['codVariable'],
      tipoDato: map['tipoDato'],
      nombreVariable: map['nombreVariable'],
      valorVariable: map['valorVariable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secRegistro': secRegistro,
      'codParametro': codParametro,
      'codVariable': codVariable,
      'tipoDato': tipoDato,
      'nombreVariable': nombreVariable,
      'valorVariable': valorVariable,
    };
  }
}
