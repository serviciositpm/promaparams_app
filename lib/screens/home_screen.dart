// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:promaparams_app/screens/screens.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:promaparams_app/ui/icon_mapper.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final camaronerasProvider =
        Provider.of<CamaronerasProvider>(context, listen: false);

    // Cargar usuario
    try {
      await userProvider.loadUser();

      // Cargar camaroneras solo si se obtuvo el usuario
      if (userProvider.usuario != null) {
        await camaronerasProvider.loadCamaroneras(userProvider.usuario!);
      }
    } catch (e) {
      // Mostrar error si ocurre
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final camaronerasProvider = Provider.of<CamaronerasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Parámetros'),
        foregroundColor: AppTheme.blanco,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: camaronerasProvider.isLoadingCamaroneras
          ? const Center(
              child: CircularProgressIndicator()) // Loader mientras carga
          : Column(
              children: [
                if (camaronerasProvider.camaroneras.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: camaronerasProvider.selectedCamaronera,
                      hint: const Text('Selecciona una camaronera'),
                      items: camaronerasProvider.camaroneras.map((camaronera) {
                        return DropdownMenuItem<String>(
                          value: camaronera['codCamaronera'],
                          child: Text(camaronera['desCamaronera'].trim()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          camaronerasProvider.setSelectedCamaronera(value);
                          camaronerasProvider.loadParametros(
                              userProvider.usuario!, value);
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                if (camaronerasProvider.isLoadingParametros)
                  const Center(child: CircularProgressIndicator())
                else if (camaronerasProvider.parametros.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: camaronerasProvider.parametros.length,
                      itemBuilder: (context, index) {
                        final parametro = camaronerasProvider.parametros[index];
                        // Obtén el ícono desde el endpoint usando IconMapper
                        final icon = IconMapper.getIcon(parametro['icon']);
                        return ListTile(
                          title: Text(parametro['descParametro']),
                          leading: Icon(icon),
                          onTap: () {
                            final codParametro =
                                parametro['codParametro']; // Conversión segura

                            if (codParametro != null &&
                                camaronerasProvider.selectedCamaronera !=
                                    null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisteredFormsScreen(
                                    codCamaronera:
                                        camaronerasProvider.selectedCamaronera!,
                                    descCamaronera: camaronerasProvider
                                            .camaroneras
                                            .firstWhere((cam) =>
                                                cam['codCamaronera'] ==
                                                camaronerasProvider
                                                    .selectedCamaronera)[
                                        'desCamaronera'],
                                    descParametro: parametro['descParametro'],
                                    codParametro:
                                        codParametro, // Pasamos el int
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Error: El parámetro no es un número válido o no se seleccionó una camaronera')),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                if (camaronerasProvider.parametros.isEmpty)
                  const Center(child: Text('No se encontraron parámetros')),
              ],
            ),
    );
  }
}
