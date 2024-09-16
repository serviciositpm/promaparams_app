import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/models/models.dart';

class RegistrosScreen extends StatefulWidget {
  final String codCamaronera;
  final String descCamaronera;
  final String descParametro;
  final String codParametro;

  const RegistrosScreen({
    required this.codCamaronera,
    required this.descCamaronera,
    required this.descParametro,
    required this.codParametro,
    super.key,
  });

  @override
  _RegistrosScreenState createState() => _RegistrosScreenState();
}

class _RegistrosScreenState extends State<RegistrosScreen> {
  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  Future<void> _loadRegistros() async {
    final registrosProvider =
        Provider.of<RegisteredParameteresProvider>(context, listen: false);
    await registrosProvider.loadRegistros(
      widget.codCamaronera,
      widget.codParametro,
      DateTime.now().year,
    );
  }

  @override
  Widget build(BuildContext context) {
    final registrosProvider =
        Provider.of<RegisteredParameteresProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.descCamaronera} - ${widget.descParametro}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: registrosProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : registrosProvider.registros.isNotEmpty
              ? ListView.builder(
                  itemCount: registrosProvider.registros.length,
                  itemBuilder: (context, index) {
                    final registro = registrosProvider.registros[index];
                    return ListTile(
                      title: Text(
                          'Piscina: ${registro.piscina}, Ciclo: ${registro.ciclo}'),
                      subtitle: Text(
                          'Fecha: ${registro.fecRegistro}, Estado: ${registro.estadoRegistro}'),
                    );
                  },
                )
              : const Center(child: Text('No se encontraron registros')),
    );
  }
}
