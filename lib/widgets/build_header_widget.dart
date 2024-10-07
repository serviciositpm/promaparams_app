// build_header.dart
import 'package:flutter/material.dart';
import 'package:promaparams_app/themes/app_themes.dart';

class BuildHeader extends StatelessWidget {
  final String descCamaronera;
  final String descParametro;
  final String id;

  const BuildHeader({
    required this.descCamaronera,
    required this.descParametro,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camaronera : ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.second,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Parámetro : ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.second,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Id : ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.second,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descCamaronera,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    descParametro,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
