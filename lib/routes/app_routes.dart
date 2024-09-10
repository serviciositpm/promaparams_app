//Se Define las rutas de mi aplicacion
import 'package:promaparams_app/models/models.dart';
import 'package:promaparams_app/screens/screens.dart';
import 'package:flutter/material.dart';

//import 'package:fl_components/models/models.dart';
//import 'package:fl_components/screens/screens.dart';

class AppRoutes {
  //Primera Opcion para Manejar las rutas
  /*
  static const initial_route = 'HomeScreen';

  static Map<String, Widget Function(BuildContext)> routes = {
    'HomeScreen': (BuildContext context) => const HomeScreen(),
    'ListView1': (BuildContext context) => const ListView1Screen(),
    'ListView2': (BuildContext context) => const ListView2Screen(),
    'Alerta': (BuildContext context) => const AlertScreen(),
    'Card': (BuildContext context) => const CardScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const AlertScreen());
  }
  */
  static const initialRoute = 'HomeScreen';
  static final menuOptions = <MenuOptions>[
    /* MenuOptions(
        route: 'registerbin',
        name: 'Registrar Guía Lista',
        screen: const AssigmentScreen(),
        icon: Icons.app_registration), */
    /* MenuOptions(
        route: 'exitplant',
        name: 'Registrar Salida Planta',
        screen: const ExitPlantListScreen(),
        icon: Icons.gite_sharp),
    MenuOptions(
        route: 'arrivefarm',
        name: 'Registrar Llegada a Granja',
        screen: const ArriveFarmListScreen(),
        icon: Icons.location_on_rounded),
    MenuOptions(
        route: 'closebin',
        name: 'Registrar Móvil Listo',
        screen: const MovilListoCMP(),
        icon: Icons.propane_tank),
    MenuOptions(
        route: 'exitfarm',
        name: 'Registrar Salida Granja',
        screen: const SalidaGranjaCMP(),
        icon: Icons.assignment_return_rounded),
    MenuOptions(
        route: 'arriveplant',
        name: 'Registrar Llegada a Planta',
        screen: const LlegadaPlantaCMP(),
        icon: Icons.factory), */
    /* MenuOptions(
        route: 'receptionbin',
        name: 'Registrar Llegada Recepciòn',
        screen: const ReceptionListScreen(),
        icon: Icons.precision_manufacturing_sharp),
    MenuOptions(
        route: 'receivebin',
        name: 'Registrar Recibido Recepciòn',
        screen: const SupllyHopperListScreen(),
        icon: Icons.flip), */

    /* MenuOptions(
        route: 'ListView1',
        name: 'List View 1',
        screen: const ListView1Screen(),
        icon: Icons.list),
    MenuOptions(
        route: 'ListView2',
        name: 'List View 2',
        screen: const ListView2Screen(),
        icon: Icons.list),
    MenuOptions(
        route: 'Alerta',
        name: 'Alertas',
        screen: const AlertScreen(),
        icon: Icons.add_alert_outlined),
    MenuOptions(
        route: 'Card',
        name: 'Cards',
        screen: const CardScreen(),
        icon: Icons.credit_card) */
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  /*
  static Map<String, Widget Function(BuildContext)> routes = {
    'HomeScreen': (BuildContext context) => const HomeScreen(),
    'ListView1': (BuildContext context) => const ListView1Screen(),
    'ListView2': (BuildContext context) => const ListView2Screen(),
    'Alerta': (BuildContext context) => const AlertScreen(),
    'Card': (BuildContext context) => const CardScreen(),
  };
  */

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const AlertScreen());
  }
}
