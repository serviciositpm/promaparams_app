import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';
import '../themes/app_themes.dart';
import 'package:promaparams_app/screens/screens.dart';

class RegisteredFormsScreen extends StatelessWidget {
  final String codCamaronera;
  final String descCamaronera;
  final String descParametro;
  final String codParametro;

  const RegisteredFormsScreen({
    required this.codCamaronera,
    required this.descCamaronera,
    required this.descParametro,
    required this.codParametro,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final registrosProvider =
        Provider.of<RegisteredParameteresProvider>(context);
    final detalleRegistrosProvider =
        Provider.of<DetalleRegistrosProvider>(context, listen: false);

    // Cargar los registros cuando se construye la pantalla
    /* if (!registrosProvider.isLoading && registrosProvider.registros.isEmpty) {
      registrosProvider.loadRegistros(
        codCamaronera,
        codParametro,
        DateTime.now().year,
      );
    } */

    return Scaffold(
      appBar: AppBar(
        title: Text(descParametro),
        foregroundColor: AppTheme.blanco,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: registrosProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : registrosProvider.registros.isNotEmpty
              ? Column(
                  children: [
                    const Divider(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    _buildHeader(),
                    _buildListView(registrosProvider),
                  ],
                )
              : const Center(
                  child: Text('No existen registros.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.second)),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          detalleRegistrosProvider.saveIdRegistro(null);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRegisterParamsVariables(
                codCamaronera: codCamaronera,
                descCamaronera: descCamaronera,
                codParametro: codParametro,
                descParametro: descParametro,
              ),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.blanco,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Método para la cabecera
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      height: 95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
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
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Parámetro : ',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Fecha Act. : ',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold),
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
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    descParametro,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateTime.now().toLocal().toString().split(' ')[0],
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.upload,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para el ListView.builder
  Widget _buildListView(RegisteredParameteresProvider registrosProvider) {
    const double tamanio = 11;
    const double tamanioTitulo = 11;

    return Expanded(
      child: ListView.builder(
        itemCount: registrosProvider.registros.length,
        itemBuilder: (context, index) {
          final registro = registrosProvider.registros[index];
          return GestureDetector(
            onTap: () {
              final detalleRegistrosProvider =
                  Provider.of<DetalleRegistrosProvider>(context, listen: false);
              detalleRegistrosProvider.getDetallesPorId(registro.id ?? 0);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRegisterParamsVariables(
                    codCamaronera: codCamaronera,
                    descCamaronera: descCamaronera,
                    codParametro: codParametro,
                    descParametro: descParametro,
                    secRegistro: registro.secRegistro.toString(),
                    id: registro.id.toString(),
                    ciclo: registro.ciclo,
                    anio: registro.anio.toString(),
                    piscina: registro.piscina,
                    piscinades: registro.despiscina,
                    fecha: registro.fecRegistro,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                width: double.infinity,
                height: 110,
                decoration: _cardBorders(),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '# Sipe :',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              'Anio : ',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              'Ciclo : ',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              'Id. Local : ',
                              style: TextStyle(
                                  fontSize: tamanio,
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
                              registro.secRegistro.toString(),
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.anio.toString(),
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.ciclo,
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.id.toString(),
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
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
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha :',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              'Cód. Pisc : ',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              '# Pisc : ',
                              style: TextStyle(
                                  fontSize: tamanioTitulo,
                                  color: AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(height: 5, color: Colors.white),
                            Text(
                              'Estado: ',
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
                              registro.fecRegistro,
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.piscina,
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.despiscina,
                              style: const TextStyle(
                                  fontSize: tamanio,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 5, color: Colors.white),
                            Text(
                              registro.estadoRegistro,
                              style: TextStyle(
                                  fontSize: tamanio,
                                  color: registro.estadoRegistro
                                              .toLowerCase() ==
                                          'aprobado'
                                      ? AppTheme.upload
                                      : registro.estadoRegistro.toLowerCase() ==
                                              'pendiente'
                                          ? AppTheme.grisoscuro
                                          : AppTheme.second,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (registro.sincronizado == 1)
                      const Icon(Icons.cloud_done,
                          size: 25, color: AppTheme.upload),
                    if (registro.sincronizado == 0)
                      const Icon(Icons.cloud_upload,
                          size: 25, color: AppTheme.second),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5)
        ],
      );
}
