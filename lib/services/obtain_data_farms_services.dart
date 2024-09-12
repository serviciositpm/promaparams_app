import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFarmService {
  final String apiUrl =
      'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras/obtenercamaronerasxusuario';

  Future<List<Map<String, dynamic>>?> obtenerCamaroneras(String usuario) async {
    final response = await http.get(Uri.parse(
        '$apiUrl?opcion=CAM&usuario=$usuario&camaronera=&anio=2024&piscina=&ciclo='));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar camaroneras');
    }
  }

  Future<List<Map<String, dynamic>>?> obtenerParametros(
      String usuario, String camaronera) async {
    final response = await http.get(Uri.parse(
        '$apiUrl?opcion=PAR&usuario=$usuario&camaronera=$camaronera&anio=2024&piscina=&ciclo='));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar parámetros');
    }
  }
}
