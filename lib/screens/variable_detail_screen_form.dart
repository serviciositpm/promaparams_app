import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:promaparams_app/providers/providers.dart';

class VariableDetailForm extends StatefulWidget {
  final String codParametro;
  final String codVariable;
  final String nombre;
  final String valorActual;
  final String tipoDato;

  const VariableDetailForm({
    super.key,
    required this.codParametro,
    required this.codVariable,
    required this.nombre,
    required this.valorActual,
    required this.tipoDato,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VariableDetailFormState createState() => _VariableDetailFormState();
}

class _VariableDetailFormState extends State<VariableDetailForm> {
  final TextEditingController _valorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _valorController.text = widget.valorActual;
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormVariableProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar Variable: ${widget.nombre}'),
          foregroundColor: AppTheme.blanco,
          backgroundColor: AppTheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Variable: ${widget.nombre}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<FormVariableProvider>(
                  builder: (context, formProvider, _) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: _valorController,
                          decoration: InputDecoration(
                            labelText: 'Valor',
                            labelStyle: const TextStyle(color: AppTheme.second),
                            errorText: formProvider.errorMessage,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppTheme.grisoscuro),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppTheme.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            formProvider.validate(value, widget.tipoDato);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.upload,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: formProvider.isValid
                              ? () {
                                  final nuevoValor = _valorController.text;
                                  if (nuevoValor.isNotEmpty) {
                                    // Actualizar el valor en la base de datos a través del provider
                                    Provider.of<VariablesProvider>(context,
                                            listen: false)
                                        .updateVariable(
                                      codParametro: widget.codParametro,
                                      codVariable: widget.codVariable,
                                      valorVariable: nuevoValor,
                                    );

                                    // Mostrar alerta de éxito
                                    _showAlert(context,
                                        'Registro guardado en base local');
                                    formProvider.reset();
                                  }
                                }
                              : null,
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.blanco,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.blanco),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((_) {
      // Volver a la pantalla anterior tras mostrar el alert
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    });
  }
}
