//Aqui se manejaran todos los estilos y diseños de los inputs
import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {
      //se añaden las caracteristicas obligatorias
      required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            /* borderSide: BorderSide(color: Colors.deepPurple)), */
            //Color del Boton
            borderSide: BorderSide(color: Color.fromARGB(41, 60, 118, 10))),
        focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(204, 13, 89, 189), width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color.fromARGB(204, 13, 89, 189))
            : null);
  }
}
