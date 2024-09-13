// icon_mapper.dart
import 'package:flutter/material.dart';

class IconMapper {
  static final Map<String, IconData> _iconMap = {
    "Icons.app_registration": Icons.app_registration,
    "Icons.home": Icons.home,
    "Icons.settings": Icons.settings,
    "Icons.build": Icons.build,
    // Agrega más íconos según sea necesario
  };

  // Devuelve el ícono si existe, o un ícono por defecto si no
  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline; // Ícono predeterminado
  }
}
