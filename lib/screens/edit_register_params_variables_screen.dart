import 'package:flutter/material.dart';
/* import 'package:intl/intl.dart'; */
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';
/* import 'package:promaparams_app/screens/screens.dart'; */
import 'package:promaparams_app/widgets/widgets.dart';

class EditRegisterParamsVariables extends StatelessWidget {
  final String codCamaronera;
  final String descCamaronera;
  final String codParametro;
  final String descParametro;
  final String secRegistro;
  final String id;
  final String ciclo;
  final String anio;
  final String piscina;
  final String piscinades;
  final String fecha;

  const EditRegisterParamsVariables({
    required this.codCamaronera,
    required this.descCamaronera,
    required this.codParametro,
    required this.descParametro,
    required this.secRegistro,
    required this.id,
    required this.ciclo,
    required this.anio,
    required this.piscina,
    required this.piscinades,
    required this.fecha,
    super.key,
  });

  /* Future<void> _fetchVariables(BuildContext context) async {
    final variablesProvider =
        Provider.of<VariablesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final poolProvider = Provider.of<PoolProvider>(context, listen: false);
    final yearProvider = Provider.of<YearProvider>(context, listen: false);
    final ciclesProvider = Provider.of<CiclesProvider>(context, listen: false);
    final detalleRegistroProvider =
        Provider.of<DetalleRegistrosProvider>(context, listen: false);
    // Verifica que todos los datos estén disponibles antes de hacer la solicitud
    if (poolProvider.selectedPiscina != null &&
        ciclesProvider.selectedCiclo != null) {
      // Primero busca en los registros locales
      if (detalleRegistroProvider.savedIdRegistro != null ||
          detalleRegistroProvider.savedIdRegistro == 0) {
        variablesProvider.clearVariables();
        detalleRegistroProvider
            .getDetallesPorId(detalleRegistroProvider.savedIdRegistro!);
      } else {
        await variablesProvider.fetchVariables(
          usuario: userProvider.usuario!,
          camaronera: codCamaronera,
          anio: yearProvider.selectedYear!,
          piscina: poolProvider.selectedPiscina!,
          ciclo: ciclesProvider.selectedCiclo!,
          fecha: DateFormat('yyyy-MM-dd').format(dateProvider.selectedDate),
          codForm: codParametro,
        );
      }
    }
  } */

  Future<void> _deleteAllRecords(BuildContext context) async {
    final dbProvider = Provider.of<VariablesProvider>(context, listen: false);
    dbProvider.clearVariables();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registros eliminados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final piscinas = Provider.of<PoolProvider>(context).piscinas;
    final ciclos = Provider.of<CiclesProvider>(context).ciclos;
    final dateProvider = Provider.of<DateProvider>(context);
    final yearProvider = Provider.of<YearProvider>(context);
    final poolProvider = Provider.of<PoolProvider>(context, listen: false);
    final ciclesProvider = Provider.of<CiclesProvider>(context, listen: false);
    /* final variablesProvider = Provider.of<VariablesProvider>(context); */
    final detalleRegistrosProvider =
        Provider.of<DetalleRegistrosProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Parámetros'),
        foregroundColor: AppTheme.blanco,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteAllRecords(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 5, color: Colors.transparent),
          BuildHeader(
              descCamaronera: descCamaronera,
              descParametro: descParametro,
              id: id),
          const Divider(height: 5, color: Colors.transparent),
          _buildRegistros(
              context,
              piscinas,
              ciclos,
              dateProvider,
              yearProvider,
              poolProvider,
              ciclesProvider,
              id,
              ciclo,
              piscina,
              anio,
              fecha,
              piscinades),
          const Divider(height: 5, color: Colors.transparent),
          Expanded(
              child: VariablesListParamsWidget(
            registroId: int.parse(id),
          )),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /* if (id == '0' || id == '')
            FloatingActionButton(
              onPressed: () =>
                  _showSaveDialog(context, detalleRegistrosProvider),
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.blanco,
              child: const Icon(Icons.save),
            ), */
          const SizedBox(height: 10),
          if (id != '0' || id != '')
            FloatingActionButtonSync(
              context: context,
              registeredParametersProvider: detalleRegistrosProvider,
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.blanco,
              idRegistro: int.parse(id),
              child: const Icon(Icons.sync),
            ),
        ],
      ),
    );
  }

  Widget _buildRegistros(
      BuildContext context,
      List piscinas,
      List ciclos,
      DateProvider dateProvider,
      YearProvider yearProvider,
      PoolProvider poolProvider,
      CiclesProvider ciclesProvider,
      idrec,
      ciclorec,
      piscinarec,
      aniorec,
      fecharec,
      piscinadesrec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Año:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      aniorec,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pisc #:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      piscinadesrec,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 10, color: Colors.transparent),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ciclo:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ciclorec,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.second,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fecharec,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* void _showSaveDialog(
      BuildContext context, DetalleRegistrosProvider detalleRegistrosProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guardar registros'),
          content: const Text(
              '¿Deseas guardar los registros en la base de datos local?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _saveRecords(context,
                    detalleRegistrosProvider); // Llama al método para guardar los registros
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  } */

  /* void _saveRecords(BuildContext context,
      DetalleRegistrosProvider detalleRegistrosProvider) async {
    final yearProvider = Provider.of<YearProvider>(context, listen: false);
    final poolProvider = Provider.of<PoolProvider>(context, listen: false);
    final ciclesProvider = Provider.of<CiclesProvider>(context, listen: false);
    final variablesProvider =
        Provider.of<VariablesProvider>(context, listen: false);
    /* final detalleRegistrosProvider =
        Provider.of<DetalleRegistrosProvider>(context, listen: false); */

    if (yearProvider.selectedYear == null ||
        poolProvider.selectedPiscina == null ||
        ciclesProvider.selectedCiclo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, seleccione Año, Piscina y Ciclo')),
      );
      return;
    }
    final now = DateTime.now();
    Registro registro = Registro(
        //id: 0,
        secRegistro: 0, // Cambia esto por el valor correcto
        codCamaronera: codCamaronera,
        descCamaronera: descCamaronera,
        codFormParametro: int.parse(codParametro),
        descFormParametro: descParametro,
        fecRegistro:
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        estadoRegistro: 'Pendiente',
        anio: int.parse(yearProvider.selectedYear!),
        piscina: poolProvider.selectedPiscina!,
        despiscina: poolProvider.selectedDesPiscina!,
        ciclo: ciclesProvider.selectedCiclo!,
        sincronizado: 0
        // Otros campos del registro
        );

    List<DetalleRegistro> detalles =
        variablesProvider.variables.map((variable) {
      return DetalleRegistro(
        secRegistro: 0, // Asegúrate de que el secRegistro sea el correcto
        codVariable: variable['codVariable']?.toString() ?? 'desconocido',
        valorVariable:
            variable['valorVariable']?.toString() ?? '0', // Manejar null
        tipoDato: variable['tipoDato']?.toString() ?? 'numeros',
        codFormParametro:
            int.tryParse(codParametro) ?? 0, // Manejar null y excepciones
        // Otros campos del detalle (asegúrate de que también estén bien)
        id: 0, // Completar con valores correctos
        codCamaronera: codCamaronera, // Completar con valores correctos
        descCamaronera: descCamaronera,
        descFormParametro: descParametro,
        fecRegistro:
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        estadoRegistro: 'Pendiente',
        anio: int.parse(yearProvider.selectedYear!),
        piscina: poolProvider.selectedPiscina!,
        despiscina: poolProvider.selectedDesPiscina!,
        ciclo: ciclesProvider.selectedCiclo!,
        nombre: variable['nombre'], // Completar según lo necesario
        sincronizado: 0, // 0 si no está sincronizado
      );
    }).toList();
    // Llamar al provider para guardar los datos
    int registroId = await detalleRegistrosProvider.insertarRegistrosDetalle(
        registro, detalles);

    detalleRegistrosProvider.saveIdRegistro(registroId);
    // Verifica si el registro fue exitoso y actualiza la interfaz si registroId es válido
    if (registroId > 0) {
      detalleRegistrosProvider.getDetallesPorId(registroId); // Cargar detalles
    }
    // Mostrar un SnackBar de confirmación
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro guardado con ID: $registroId')),
    );
  } */
}
