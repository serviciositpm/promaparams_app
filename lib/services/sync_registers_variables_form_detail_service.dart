import 'dart:convert';
import 'package:http/http.dart' as http;

class SyncVariablesFormDetailsService {
  final String apiUrl =
      'http://10.20.4.195:8185/api-app-registro-prametros-camaroneras/insertaractualizarregistrosparametros';

  Future<bool> syncData(List<Map<String, dynamic>> registros) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registros),
      );

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Verificar si el API retornó los valores esperados
        if (responseData['codMsg'] == 200 &&
            responseData['descMsg'] == 'Registros Recibidos') {
          return true; // Sincronización exitosa
        } else {
          throw Exception(
              'Respuesta de API inesperada: ${responseData['descMsg']}');
        }
      } else {
        throw Exception(
            'Error al conectar con el servidor. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores
      // ignore: avoid_print
      print('Error en syncData: $e');
      return false;
    }
  }
}
