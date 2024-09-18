import 'dart:convert';
import 'package:http/http.dart' as http;

class PoolServices {
  Future<List<Map<String, String>>> getPools({
    required String usuario,
    required String camaronera,
    required String anio,
  }) async {
    final url = Uri.parse(
      'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras/obtenercamaronerasxusuario?opcion=PIS&usuario=$usuario&camaronera=$camaronera&anio=$anio&piscina=&ciclo=',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Convertir los valores a String explícitamente
      return data.map((piscina) {
        return {
          'codPiscina': piscina['codPiscina'].toString(),
          'numPiscina': piscina['numPiscina'].toString().trim(),
        };
      }).toList();
    } else {
      throw Exception('Error al obtener piscinas');
    }
  }
}
