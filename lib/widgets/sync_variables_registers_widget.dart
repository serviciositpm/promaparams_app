import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';

class FloatingActionButtonSync extends StatelessWidget {
  final BuildContext context;
  final DetalleRegistrosProvider registeredParametersProvider;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;

  const FloatingActionButtonSync({
    required this.context,
    required this.registeredParametersProvider,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncVariablesFormDetailsProvider>(context);
    final detalelRegistrosForm = Provider.of<DetalleRegistrosProvider>(context);

    return FloatingActionButton(
      onPressed: syncProvider.isSyncing
          ? null
          : () async {
              // Obtener el id del registro desde el provider
              final idRegistro = detalelRegistrosForm.savedIdRegistro;

              if (idRegistro != null) {
                // Obtener los detalles de los registros por ID
                final registrosDetalles = await registeredParametersProvider
                    .getDetallesPorId(idRegistro);

                // Convertir los detalles a List<Map<String, dynamic>> para la sincronización
                final registrosMap = registrosDetalles
                    .map((detalle) => detalle.toMap())
                    .toList();

                // Llamar al método sync del provider
                await syncProvider.syncData(registrosMap);

                // Mostrar notificación cuando se completa la sincronización
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(syncProvider.syncStatus)),
                );

                // Actualizar los registros después de la sincronización
                /* await registeredParametersProvider.updateLocalDatabaseAfterSync(); */
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('No hay registros para sincronizar')),
                );
              }
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
