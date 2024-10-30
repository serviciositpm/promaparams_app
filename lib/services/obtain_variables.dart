import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiVariablesServices {
  Future<List<Map<String, dynamic>>> fetchVariables({
    required String usuario,
    required String camaronera,
    required String anio,
    required String piscina,
    required String ciclo,
    required String fecha,
    required String codForm,
  }) async {
    final url = Uri.parse(
        /* 'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras/obtenerregistrosparametros?opcion=DVP&usuario=$usuario&camaronera=$camaronera&anio=$anio&piscina=$piscina&ciclo=$ciclo&fecha=$fecha&codform=$codForm'); */
        'http://10.100.120.35:8185/api-app-registro-prametros-camaroneras/obtenerregistrosparametros?opcion=DVP&usuario=$usuario&camaronera=$camaronera&anio=$anio&piscina=$piscina&ciclo=$ciclo&fecha=$fecha&codform=$codForm');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las variables');
    }
  }
}
