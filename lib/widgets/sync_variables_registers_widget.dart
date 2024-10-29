import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';

class FloatingActionButtonSync extends StatelessWidget {
  final BuildContext context;
  final DetalleRegistrosProvider registeredParametersProvider;
  final Color backgroundColor;
  final Color foregroundColor;
  final int idRegistro;
  final String codCamaronera;
  final String codParametro;
  final String anio;
  final Widget child;

  const FloatingActionButtonSync({
    required this.context,
    required this.registeredParametersProvider,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.idRegistro,
    required this.codCamaronera,
    required this.codParametro,
    required this.anio,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncVariablesFormDetailsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final detalleRegistros =
        Provider.of<DetalleRegistrosProvider>(context, listen: false);

    final registrosProvider =
        Provider.of<RegisteredParameteresProvider>(context, listen: false);

    return FloatingActionButton(
      onPressed: syncProvider.isSyncing
          ? null
          : () async {
              // Obtener el id del registro desde el provider
              /* final idRegistro = detalelRegistrosForm.savedIdRegistro; */

              // Obtener los detalles de los registros por ID
              final registrosDetalles = await registeredParametersProvider
                  .getDetallesPorId(idRegistro);

              // Convertir los detalles a List<Map<String, dynamic>> para la sincronización
              /* final registrosMap =
                  registrosDetalles.map((detalle) => detalle.toMap()).toList(); */
              final registrosMap = registrosDetalles.map((detalle) {
                final detalleMap = detalle.toMap();

                // Agregar codUsuario al mapa
                detalleMap['codUsuario'] = userProvider.usuario;

                return detalleMap;
              }).toList();

              // Llamar al método sync del provider
              await syncProvider.syncData(registrosMap);

              detalleRegistros.clearVariablesDetalle();
              detalleRegistros.getDetallesPorId(idRegistro);
              registrosProvider.loadRegistros(
                  codCamaronera, codParametro, int.parse(anio));
              // Mostrar notificación cuando se completa la sincronización
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(syncProvider.syncStatus)),
              );

              // Actualizar los registros después de la sincronización
              /* await registeredParametersProvider.updateLocalDatabaseAfterSync(); */
            },
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: syncProvider.isSyncing
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : child,
    );
  }
}
