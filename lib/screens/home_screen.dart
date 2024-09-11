/* import 'package:bines_app/providers/providers.dart'; */
import 'package:promaparams_app/routes/app_routes.dart';
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:flutter/material.dart';
/* import 'package:provider/provider.dart'; */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* final listaGuiasAsignadas = Provider.of<AssiggrListProvider>(context); */
    final menuOptions = AppRoutes.menuOptions;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Parámetros '),
        foregroundColor: AppTheme.blanco,
        //agregar boton para logout
        actions: [
          IconButton(
              onPressed: () {
                //aqui se debe controlar quitar la
                //authServices.logout();
              },
              icon: const Icon(Icons.cloud_sync)),
          IconButton(
              onPressed: () {
                //aqui se debe controlar quitar la
                //authServices.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ), //Este Widget permite tener un separador entre cada linea del listview
      body: ListView.separated(
        itemCount: menuOptions.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(menuOptions[index].name,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          leading: Icon(
            menuOptions[index].icon,
            color: AppTheme.primary,
          ),
          //permite seleccionar el elemencto de la lista
          onTap: () {
            /*
             * Servicio que invoca al provider que refresca los datos de las pantallas
             */
            /* final ServicesProviderCMP dataGuiasDayServices =
                Provider.of<ServicesProviderCMP>(context, listen: false); */

            switch (index) {
              //-------------------------
              //Registro de Bines
              //-------------------------
              case 0: // Registro Salida Planta
              /* dataGuiasDayServices.llamarApiGuiasRegistradas(
                    '', 'GUIAPESCAD', '1206702175');
                break; */
              //-------------------------
              //Registro Salida de Planta
              //-------------------------
              case 1: //Opcion de Registro Salida de Planta
              /* dataGuiasDayServices.llamarApiGuiasRegistradas(
                    '', 'GUIALLEGGR', '1206702175');

                break; */

              //-------------------------
              //Registro de Móvil Listo
              //-------------------------
              case 2: //Opcion de  Registro Llegada Granja
              /* dataGuiasDayServices.llamarApiGuiasRegistradas(
                    '', 'GMOVILLIST', '1206702175');
                break; */

              //-------------------------
              //Registro Salida de Granja
              //-------------------------
              case 3:
              /* listadoGR.cargarGrRegistradas('RCB');
                break; //Regitro Salida Planta */
              /* dataGuiasDayServices.llamarApiGuiasRegistradas(
                    '', 'GUIASALGRA', '1206702175');
                break; */ //Registro de Salida de Granja
              //-------------------------
              //Registro Llegada Planta
              //-------------------------
              case 4:
              /* dataGuiasDayServices.llamarApiGuiasRegistradas(
                    '', 'GUIALLEGPL', '1206702175');
                break; */ //Registro de Salida de Granja
            }
            Navigator.pushNamed(context, menuOptions[index].route);
          },
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: AppTheme.primary,
          ),
        ),
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
