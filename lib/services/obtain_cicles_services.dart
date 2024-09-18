import 'dart:convert';
import 'package:http/http.dart' as http;

class CiclesServices {
  Future<List<Map<String, String>>> getCicles({
    required String usuario,
    required String camaronera,
    required String anio,
    required String piscina,
  }) async {
    final url = Uri.parse(
      'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras/obtenercamaronerasxusuario?opcion=CIC&usuario=$usuario&camaronera=$camaronera&anio=$anio&piscina=$piscina&ciclo=',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // Convertir los valores a String explícitamente
      return data.map((ciclo) {
        return {
          'ciclo': ciclo['ciclo'].toString(),
        };
      }).toList();
    } else {
      throw Exception('Error al obtener los ciclos');
    }
  }
}
