import 'package:flutter/material.dart';
import 'package:promaparams_app/models/models.dart';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:promaparams_app/screens/screens.dart';
import 'package:provider/provider.dart';

class VariablesListParamsWidget extends StatelessWidget {
  final int registroId;

  const VariablesListParamsWidget({
    super.key,
    required this.registroId,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos FutureBuilder para cargar los datos antes de construir la UI
    return FutureBuilder(
      future: _fetchVariables(context), // Método para obtener los detalles
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los datos'));
        }

        final detalleProvider = Provider.of<DetalleRegistrosProvider>(context);

        if (detalleProvider.detalles.isEmpty) {
          return const Center(child: Text('No hay datos para mostrar'));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: detalleProvider.detalles.length,
            itemBuilder: (BuildContext context, int index) {
              final detalle = detalleProvider.detalles[index];
              return GestureDetector(
                onTap: () => _onVariableTap(context, detalle),
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  width: double.infinity,
                  height: 90,
                  decoration: _cardBorders(),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 15)),
                      const Icon(Icons.edit_document,
                          size: 25, color: AppTheme.grisoscuro),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Variable :',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.second,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(height: 5, color: Colors.white),
                              Text(
                                'Tipo Dato :',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.second,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(height: 5, color: Colors.white),
                              Text(
                                'Valor :',
                                style: TextStyle(
                                    fontSize: 12,
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
                                detalle.nombre,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(height: 5, color: Colors.white),
                              Text(
                                detalle.tipoDato,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(height: 5, color: Colors.white),
                              Text(
                                detalle.valorVariable,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              /* Text(
                                detalle.sincronizado.toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold),
                              ), */
                            ],
                          ),
                        ),
                      ),
                      if (detalle.sincronizado == 1)
                        const Icon(Icons.cloud_done,
                            size: 25, color: AppTheme.upload),
                      if (detalle.sincronizado == 0)
                        const Icon(Icons.cloud_upload,
                            size: 25, color: AppTheme.second),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      const Icon(Icons.storage,
                          size: 25, color: AppTheme.grisoscuro),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _fetchVariables(BuildContext context) async {
    final detalleProvider =
        Provider.of<DetalleRegistrosProvider>(context, listen: false);
    await detalleProvider.getDetallesPorId(registroId);
  }

  // Acción al hacer tap en una variable
  void _onVariableTap(BuildContext context, DetalleRegistro detalle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VariableDetailForm(
          codParametro: detalle.codFormParametro.toString(),
          codVariable: detalle.codVariable,
          nombre: detalle.nombre,
          valorActual: detalle.valorVariable,
          tipoDato: detalle.tipoDato,
          registroId: registroId,
          codCamaronera: detalle.codCamaronera,
        ),
      ),
    );
  }

  // Decoración del card
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
