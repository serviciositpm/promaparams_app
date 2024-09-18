import 'package:flutter/material.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:promaparams_app/providers/providers.dart';

class AddRegisterParamsVariables extends StatefulWidget {
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

  @override
  // ignore: library_private_types_in_public_api
  _AddRegisterParamsVariablesState createState() =>
      _AddRegisterParamsVariablesState();
}

class _AddRegisterParamsVariablesState
    extends State<AddRegisterParamsVariables> {
  String? selectedPiscina;
  String? selectedCiclo;
  String? selectedAnio;
  DateTime selectedDate = DateTime.now();
  List<String> anios = []; // Lista para almacenar los años

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Inicializa la lista de años y carga las piscinas para el año actual
    _loadYears();
    _loadPiscinas();
  }

  void _loadYears() {
    final currentYear = DateTime.now().year.toString();
    setState(() {
      anios = List.generate(
          1, (index) => (int.parse(currentYear) - index).toString());
      selectedAnio = currentYear; // Seleccionar el año actual por defecto
    });
  }

  Future<void> _loadPiscinas() async {
    // Obtener el usuario desde UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final usuario = userProvider.usuario;

    if (usuario != null && selectedAnio != null) {
      // Llamar al provider para cargar las piscinas
      Provider.of<PoolProvider>(context, listen: false).fetchPiscinas(
        usuario: usuario,
        camaronera: widget.codCamaronera,
        anio: selectedAnio!,
      );
    }
  }

  Future<void> _loadCiclos(String codPiscina) async {
    // Obtener el usuario desde UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final usuario = userProvider.usuario;

    if (usuario != null && selectedAnio != null) {
      Provider.of<CiclesProvider>(context, listen: false).fetchCiclos(
        usuario: usuario,
        camaronera: widget.codCamaronera,
        anio: selectedAnio!,
        piscina: codPiscina,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final piscinas = Provider.of<PoolProvider>(context).piscinas;
    final ciclos = Provider.of<CiclesProvider>(context).ciclos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Parámetros'),
        foregroundColor: AppTheme.blanco,
      ),
      body: Column(
        children: [
          const Divider(
            height: 5,
            color: Colors.transparent,
          ),
          _buildHeader(),
          const Divider(
            height: 5,
            color: Colors.transparent,
          ),
          _buildRegistros(
              piscinas, ciclos), // Pasamos piscinas y ciclos al método
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 65,
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
                    widget.descCamaronera,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.descParametro,
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

  Widget _buildRegistros(List piscinas, List ciclos) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          ListTile(
            title:
                Text('Fecha: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Seleccionar Año'),
            value: selectedAnio,
            items: anios.map((anio) {
              return DropdownMenuItem<String>(
                value: anio,
                child: Text(anio),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedAnio = value;
                _loadPiscinas(); // Actualizar piscinas al seleccionar un nuevo año
              });
            },
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Seleccionar Piscina'),
            value: selectedPiscina,
            items: piscinas
                .map((p) => DropdownMenuItem<String>(
                      value: p['codPiscina'],
                      child: Text(p['numPiscina']!),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPiscina = value;
              });
              _loadCiclos(
                  value!); // Cargar ciclos cuando se seleccione una piscina
            },
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Seleccionar Ciclo'),
            value: selectedCiclo,
            items: ciclos
                .map((c) => DropdownMenuItem<String>(
                      value: c['ciclo'],
                      child: Text(c['ciclo']!),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCiclo = value;
              });
            },
          ),
          // Aquí puedes continuar agregando el resto de la lógica para cargar y registrar datos
        ],
      ),
    );
  }
}
