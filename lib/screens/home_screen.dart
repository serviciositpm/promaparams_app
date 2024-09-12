import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/providers/providers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final camaronerasProvider = Provider.of<CamaronerasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Parámetros'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: camaronerasProvider.isLoadingCamaroneras
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (camaronerasProvider.camaroneras.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: camaronerasProvider.camaroneras.isEmpty
                          ? null
                          : camaronerasProvider.camaroneras[0]['codCamaronera'],
                      hint: const Text('Selecciona una camaronera'),
                      items: camaronerasProvider.camaroneras.map((camaronera) {
                        return DropdownMenuItem<String>(
                          value: camaronera['codCamaronera'],
                          child: Text(camaronera['desCamaronera'].trim()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
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
                        return ListTile(
                          title: Text(parametro['descParametro']),
                          leading: const Icon(Icons.app_registration),
                          onTap: () {
                            Navigator.pushNamed(context, parametro['route']);
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
