import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceRegisteredParams {
  final String baseUrl =
      'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras';

  Future<List<dynamic>> obtenerRegistrosParametros(
      {required String opcion,
      required String usuario,
      required String camaronera,
      required int anio,
      required String piscina,
      required String ciclo,
      required String fecha,
      required int codform}) async {
    final url = Uri.parse(
        '$baseUrl/obtenerregistrosparametros?opcion=$opcion&usuario=$usuario&camaronera=$camaronera&anio=$anio&piscina=$piscina&ciclo=$ciclo&fecha=$fecha&codform=$codform');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener registros');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error en el api >> $e');
      rethrow;
    }
  }
}
