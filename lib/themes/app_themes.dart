import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromARGB(255, 5, 48, 83);
  static const Color second = Color.fromARGB(246, 131, 18, 18);
  static const Color upload = Color.fromARGB(246, 30, 102, 15);
  static const Color grisoscuro = Color.fromARGB(246, 127, 129, 127);
  static const Color blanco = Color.fromARGB(255, 243, 243, 243);

  static final ThemeData lighthTheme = ThemeData.light().copyWith(
    //COlor Primario
    primaryColor: primary,
    //apBar Thema
    appBarTheme: const AppBarTheme(color: primary, elevation: 5),
    //colores de Floating Action Button
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: primary),

    //Text Botton Theme
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary)),
    scaffoldBackgroundColor: Colors.grey[300],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      //COlor Primario
      primaryColor: primary,
      //apBar Thema
      appBarTheme: const AppBarTheme(color: primary, elevation: 5),
      scaffoldBackgroundColor: Colors.black);
}
