import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidaLoginServices {
  static const String baseUrl =
      'http://10.100.120.35:8077/api-app-control-time';

  static Future<http.Response> validarUsuario(
      String user, String password) async {
    /* final body = jsonEncode({
      'userpm': user,
      'passwordpm': password,
    }); */

    final response = await http.post(
        //10.20.4.173:8077 Servidor Desarrollo
        Uri.parse('http://10.100.120.35:8077/api-app-control-time/validarusr'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"userpm": user, "passwordpm": password}));

    return response;
  }
}
