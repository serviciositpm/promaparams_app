import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/screens/screens.dart';

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

    // Verifica que todos los datos estén disponibles antes de hacer la solicitud
    if (poolProvider.selectedPiscina != null &&
        ciclesProvider.selectedCiclo != null) {
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

  void _onPoolChange(BuildContext context) {
    final variablesProvider =
        Provider.of<VariablesProvider>(context, listen: false);
    variablesProvider.clearVariables();
  }

  /* void _onCicloChange(BuildContext context) {
    _fetchVariables(context);
  } */

  Future<void> _deleteAllRecords(BuildContext context) async {
    final dbProvider = Provider.of<VariablesProvider>(context, listen: false);
    dbProvider.clearVariables();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registros eliminados')),
    );
  }

  void _onVariableTap(BuildContext context, dynamic variable) {
    // Asegurarse de que el valor sea String y manejar null
    String codParametro = variable['codParametro'].toString();
    String codVariable = variable['codVariable'].toString();
    String nombre = variable['nombre']?.toString() ?? 'Desconocido';
    String valorActual = variable['valorVariable']?.toString() ??
        '0'; // Manejar null con un valor predeterminado
    String tipoDato = variable['tipoDato'].toString();
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
        ),
      ),
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
          _buildHeader(),
          const Divider(height: 5, color: Colors.transparent),
          _buildRegistros(context, piscinas, ciclos, dateProvider, yearProvider,
              poolProvider, ciclesProvider),
          const Divider(height: 5, color: Colors.transparent),
          Expanded(child: _buildVariablesList(context, variablesProvider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSaveDialog(context, detalleRegistrosProvider),
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 65,
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
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Parámetro : ',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariablesList(
      BuildContext context, VariablesProvider variablesProvider) {
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
            onTap: () => _onVariableTap(context, variable),
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: double.infinity,
              height: 90,
              decoration: _cardBorders(),
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
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              (variable['tipoDato'] == 'numeros' ? '0.00' : ''),
                          style: const TextStyle(
                              fontSize: tamanio,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  //Sincronizado
                  const Icon(Icons.cloud_done,
                      size: 25, color: AppTheme.upload),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  //No Sincronizado
                  const Icon(Icons.cloud_upload,
                      size: 25, color: AppTheme.second),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  //Registro Creado
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

    /* return ListView.builder(
      itemCount: variablesProvider.variables.length,
      itemBuilder: (context, index) {
        final variable = variablesProvider.variables[index];
        return ListTile(
          title: Text(variable['nombre']),
          subtitle: Text('Tipo: ${variable['tipoDato']}'),
          onTap: () => _onVariableTap(context, variable),
        );
      },
    ); */
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
                        ciclesProvider.clearCiclos();
                        if (yearProvider.selectedYear != null &&
                            poolProvider.selectedPiscina != null) {
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
                            // ignore: use_build_context_synchronously
                            _onPoolChange(context); // Limpiar variables
                          });
                        }
                        /* _onPoolChange(context); */
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

    Registro registro = Registro(
        secRegistro: 0, // Cambia esto por el valor correcto
        codCamaronera: codCamaronera,
        descCamaronera: descCamaronera,
        codFormParametro: int.parse(codParametro),
        descFormParametro: descParametro,
        fecRegistro: DateTime.now().toString(),
        estadoRegistro: 'Pendiente',
        anio: int.parse(yearProvider.selectedYear!),
        piscina: poolProvider.selectedPiscina!,
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
        fecRegistro: DateTime.now().toString(), // Fecha actual
        estadoRegistro: 'Pendiente',
        anio: int.parse(yearProvider.selectedYear!),
        piscina: poolProvider.selectedPiscina!,
        ciclo: ciclesProvider.selectedCiclo!,
        nombre: variable['nombre'], // Completar según lo necesario
        sincronizado: 0, // 0 si no está sincronizado
      );
    }).toList();

    // Llamar al provider para guardar los datos
    await detalleRegistrosProvider.insertarRegistrosDetalle(registro, detalles);

    // Mostrar un SnackBar de confirmación
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos almacenados localmente')),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 10)
        ],
      );
}
