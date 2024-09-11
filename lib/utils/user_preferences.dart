import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Guardar usuario en las preferencias
  Future<void> saveUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  // Obtener usuario de las preferencias
  Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  // Eliminar el usuario de las preferencias (por si se necesita)
  Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
