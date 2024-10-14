import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/widgets/widgets.dart';

class AddRegisterParamsVariables extends StatelessWidget {
  final String codCamaronera;
  final String descCamaronera;
  final String codParametro;
  final String descParametro;

  const AddRegisterParamsVariables({
    required this.codCamaronera,
    required this.descCamaronera,
    required this.codParametro,
    required this.descParametro,
    super.key,
  });

  Future<void> _selectDate(BuildContext context) async {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateProvider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != dateProvider.selectedDate) {
      dateProvider.setDate(picked);
    }
  }

  Future<void> _fetchVariables(BuildContext context) async {
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
  }

  void _onPoolChange(BuildContext context) {
    final variablesProvider =
        Provider.of<VariablesProvider>(context, listen: false);
    variablesProvider.clearVariables();
  }

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
    final variablesProvider = Provider.of<VariablesProvider>(context);
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
              id: detalleRegistrosProvider.savedIdRegistro != 0
                  ? detalleRegistrosProvider.savedIdRegistro != null
                      ? detalleRegistrosProvider.savedIdRegistro.toString()
                      : ''
                  : ''),
          const Divider(height: 5, color: Colors.transparent),
          _buildRegistros(context, piscinas, ciclos, dateProvider, yearProvider,
              poolProvider, ciclesProvider),
          const Divider(height: 5, color: Colors.transparent),
          Expanded(
              child: detalleRegistrosProvider.savedIdRegistro == null ||
                      detalleRegistrosProvider.savedIdRegistro == 0
                  ? VariablesListWidget(
                      variablesProvider: variablesProvider,
                      registroId: detalleRegistrosProvider.savedIdRegistro ?? 0)
                  : VariablesListParamsWidget(
                      registroId:
                          detalleRegistrosProvider.savedIdRegistro ?? 0)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (detalleRegistrosProvider.savedIdRegistro == null ||
              detalleRegistrosProvider.savedIdRegistro == 0)
            FloatingActionButton(
              onPressed: () =>
                  _showSaveDialog(context, detalleRegistrosProvider),
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.blanco,
              child: const Icon(Icons.save),
            ),
          const SizedBox(height: 10),
          if (detalleRegistrosProvider.savedIdRegistro != null ||
              detalleRegistrosProvider.savedIdRegistro != 0)
            FloatingActionButtonSync(
              context: context,
              registeredParametersProvider: detalleRegistrosProvider,
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.blanco,
              idRegistro: detalleRegistrosProvider.savedIdRegistro ?? 0,
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
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 180,
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
                    DropdownButtonFormField<String>(
                      hint: const Text('Seleccionar Año'),
                      value: yearProvider.selectedYear,
                      items: yearProvider.years.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        yearProvider.setYear(value!);
                        poolProvider
                            .fetchPiscinas(
                          usuario:
                              Provider.of<UserProvider>(context, listen: false)
                                  .usuario!,
                          camaronera: codCamaronera,
                          anio: value,
                        )
                            .then((_) {
                          poolProvider.setPiscina(
                              poolProvider.piscinas.isNotEmpty
                                  ? poolProvider.piscinas.first['codPiscina']!
                                  : '');
                        });
                      },
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
                    DropdownButtonFormField<String>(
                      hint: const Text('Seleccionar Piscina'),
                      value: poolProvider.selectedPiscina,
                      items: piscinas.map((p) {
                        return DropdownMenuItem<String>(
                          value: p['codPiscina'],
                          child: Text(p['numPiscina']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        poolProvider.setPiscina(value!);
                        // Cargar ciclos antes de asignar la descripción
                        if (yearProvider.selectedYear != null &&
                            poolProvider.selectedPiscina != null) {
                          ciclesProvider.clearCiclos();
                          // Cargar los ciclos basados en la piscina seleccionada
                          ciclesProvider
                              .fetchCiclos(
                            usuario: Provider.of<UserProvider>(context,
                                    listen: false)
                                .usuario!,
                            camaronera: codCamaronera,
                            anio: yearProvider.selectedYear!,
                            piscina: value,
                          )
                              .then((_) {
                            // Después de cargar los ciclos, asignar la descripción de la piscina
                            final piscinaSeleccionada = piscinas.firstWhere(
                              (p) => p['codPiscina'] == value,
                              /* orElse: () => null, */
                            );

                            if (piscinaSeleccionada != null) {
                              poolProvider.setDesPiscina(
                                  piscinaSeleccionada['numPiscina']!);
                            }
                          });

                          // Limpiar variables si es necesario
                          _onPoolChange(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Por favor, selecciona un año')),
                          );
                        }
                      },
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
                    DropdownButtonFormField<String>(
                      hint: const Text('Seleccionar Ciclo'),
                      value: ciclesProvider.selectedCiclo,
                      items: ciclos.map((ciclo) {
                        return DropdownMenuItem<String>(
                          value: ciclo['ciclo'],
                          child: Text(ciclo['ciclo']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        ciclesProvider.setCiclo(value!);
                        /* _onCicloChange(context); */
                        _fetchVariables(context);
                      },
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
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text(
                          DateFormat('yyyy-MM-dd')
                              .format(dateProvider.selectedDate),
                        ),
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

  void _showSaveDialog(
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
  }

  void _saveRecords(BuildContext context,
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
      // Limpiar las variables
      variablesProvider.clearVariables();
      detalleRegistrosProvider.getDetallesPorId(registroId); // Cargar detalles
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro guardado con ID: $registroId')),
      );
    }
  }
}
