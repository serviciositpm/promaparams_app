import 'package:flutter/material.dart';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:promaparams_app/screens/screens.dart';

class VariablesListWidget extends StatelessWidget {
  final VariablesProvider variablesProvider;
  final int registroId;

  const VariablesListWidget({
    super.key,
    required this.variablesProvider,
    required this.registroId,
  });

  @override
  Widget build(BuildContext context) {
    const double tamanio = 12;
    const double tamanioTitulo = 12;

    if (variablesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (variablesProvider.variables.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: variablesProvider.variables.length,
        itemBuilder: (BuildContext context, int index) {
          final variable = variablesProvider.variables[index];
          return GestureDetector(
            onTap: () => _onVariableTap(context, variable,
                registroId), // Asegúrate de que este método esté disponible.
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: double.infinity,
              height: 120,
              decoration:
                  _cardBorders(), // Asegúrate de que esta función esté disponible.
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cod. Variable :',
                            style: TextStyle(
                                fontSize: tamanioTitulo,
                                color: AppTheme.second,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(height: 5, color: Colors.white),
                          Text(
                            'Variable :',
                            style: TextStyle(
                                fontSize: tamanioTitulo,
                                color: AppTheme.second,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(height: 5, color: Colors.white),
                          Text(
                            'Tipo Dato :',
                            style: TextStyle(
                                fontSize: tamanioTitulo,
                                color: AppTheme.second,
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(height: 5, color: Colors.white),
                          Text(
                            'Valor :',
                            style: TextStyle(
                                fontSize: tamanioTitulo,
                                color: AppTheme.second,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variable['codVariable'].toString(),
                            style: const TextStyle(
                                fontSize: tamanio,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 5, color: Colors.white),
                          Text(
                            variable['nombre'],
                            style: const TextStyle(
                                fontSize: tamanio,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 5, color: Colors.white),
                          Text(
                            variable['tipoDato'],
                            style: const TextStyle(
                                fontSize: tamanio,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 5, color: Colors.white),
                          Text(
                            variable['valorVariable'] ??
                                (variable['tipoDato'] == 'numeros'
                                    ? '0.00'
                                    : ''),
                            style: const TextStyle(
                                fontSize: tamanio,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* const Icon(Icons.cloud_done,
                      size: 25, color: AppTheme.upload),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  const Icon(Icons.cloud_upload,
                      size: 25, color: AppTheme.second),
                  const Padding(padding: EdgeInsets.only(right: 10)), */
                  const Icon(Icons.pending_actions,
                      size: 25, color: AppTheme.grisoscuro),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onVariableTap(BuildContext context, dynamic variable, int registroId) {
    // Asegurarse de que el valor sea String y manejar null
    String codParametro = variable['codParametro'].toString();
    String codVariable = variable['codVariable'].toString();
    String nombre = variable['nombre']?.toString() ?? 'Desconocido';
    String valorActual = variable['valorVariable']?.toString() ??
        '0'; // Manejar null con un valor predeterminado
    String tipoDato = variable['tipoDato'].toString();
    String codCamaronera = variable['codCamaronera'].toString();
    // Redirigir al formulario de detalle de variable
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VariableDetailForm(
          codParametro: codParametro,
          codVariable: codVariable,
          nombre: nombre,
          valorActual: valorActual,
          tipoDato: tipoDato,
          registroId: registroId,
          codCamaronera: codCamaronera,
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppTheme.primary, width: 1),
      boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 10)
      ],
    );
  }
}
