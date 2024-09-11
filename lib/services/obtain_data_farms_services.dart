import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFarmService {
  Future<List<String>> fetchDropdownData(String user) async {
    try {
      final response = await http.get(
        Uri.parse('https://your-api-url.com/endpoint_dropdown?user=$user'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item['name'].toString()).toList();
      } else {
        throw Exception(
            'Error en la respuesta de la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  Future<List<String>> fetchListViewData(
      String user, String selectedItem) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://your-api-url.com/endpoint_listview?user=$user&item=$selectedItem'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item['list_item'].toString()).toList();
      } else {
        throw Exception(
            'Error en la respuesta de la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}
