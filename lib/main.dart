import 'package:promaparams_app/screens/screens.dart';
import 'package:promaparams_app/providers/providers.dart';
/* import 'package:promaparams_app/services/services.dart'; */
import 'package:promaparams_app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppsState());

//Con este mantendremos actualizados siempre los datos
class AppsState extends StatelessWidget {
  const AppsState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CamaronerasProvider()),
        ChangeNotifierProvider(create: (_) => RegisteredParameteresProvider()),
        ChangeNotifierProvider(create: (_) => PoolProvider()),
        ChangeNotifierProvider(create: (_) => CiclesProvider()),
        ChangeNotifierProvider(create: (_) => YearProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => VariablesProvider()),
        ChangeNotifierProvider(create: (_) => FormVariableProvider()),
        ChangeNotifierProvider(create: (_) => DetalleRegistrosProvider()),
        ChangeNotifierProvider(
            create: (_) => SyncVariablesFormDetailsProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final Color colorPrincipal = Colors.indigo;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grupo NP BinesApp',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(), //Pantalla de Logueo
        /* 'register': (_) => const RegisterScreen(), */ //Registro de Nuevo Uuario
        'home': (_) => const HomeScreen(), //Pagina Principal lista de Opciones
        'obtainregisteredforms': (_) => const RegisteredFormsScreen(
              codCamaronera: '',
              descCamaronera: '',
              descParametro: '',
              codParametro: '',
            ), //Pagina Principal lista de Opciones
        'addregistervaribales': (_) => const AddRegisterParamsVariables(
              codCamaronera: '',
              descCamaronera: '',
              descParametro: '',
              codParametro: '',
            ),
      },
      theme: AppTheme.lighthTheme,
    );
  }
}
