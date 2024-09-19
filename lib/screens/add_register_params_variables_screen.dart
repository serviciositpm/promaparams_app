import 'package:flutter/material.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:promaparams_app/providers/providers.dart';

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

  @override
  Widget build(BuildContext context) {
    final piscinas = Provider.of<PoolProvider>(context).piscinas;
    final ciclos = Provider.of<CiclesProvider>(context).ciclos;
    final dateProvider = Provider.of<DateProvider>(context);
    final yearProvider = Provider.of<YearProvider>(context);
    final poolProvider = Provider.of<PoolProvider>(context, listen: false);
    final ciclesProvider = Provider.of<CiclesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Parámetros'),
        foregroundColor: AppTheme.blanco,
      ),
      body: Column(
        children: [
          const Divider(height: 5, color: Colors.transparent),
          _buildHeader(),
          const Divider(height: 5, color: Colors.transparent),
          _buildRegistros(context, piscinas, ciclos, dateProvider, yearProvider,
              poolProvider, ciclesProvider),
        ],
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
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
                'Fecha: ${DateFormat('yyyy-MM-dd').format(dateProvider.selectedDate)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
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
              poolProvider.fetchPiscinas(
                usuario:
                    Provider.of<UserProvider>(context, listen: false).usuario!,
                camaronera: codCamaronera,
                anio: value,
              );
            },
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
              ciclesProvider.fetchCiclos(
                usuario:
                    Provider.of<UserProvider>(context, listen: false).usuario!,
                camaronera: codCamaronera,
                anio: yearProvider.selectedYear!,
                piscina: value,
              );
            },
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Seleccionar Ciclo'),
            value: ciclesProvider.selectedCiclo,
            items: ciclos.map((c) {
              return DropdownMenuItem<String>(
                value: c['ciclo'],
                child: Text(c['ciclo']!),
              );
            }).toList(),
            onChanged: (value) {
              ciclesProvider.setCiclo(value!);
            },
          ),
        ],
      ),
    );
  }
}
