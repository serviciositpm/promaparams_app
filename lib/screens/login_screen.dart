import 'dart:convert';
import 'package:promaparams_app/providers/providers.dart';
import 'package:promaparams_app/ui/imput_decorations.dart';
import 'package:promaparams_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promaparams_app/services/valida_login_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 250),
          CardContainer(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text('Login',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                    create: (_) => LoginFormaProvider(),
                    child: const _LoginForm()),
              ],
            ),
          ),
          const SizedBox(height: 50),
          //TODO Se Elimina el Registrar Cuenta hasta los siguientes entregables
          /* TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'register');
            },
            /* style: ButtonStyle(
                  overlayColor:
                    MaterialStateProperty.all(Colors.red.withOpacity(0.1)), 
                backgroundColor: MaterialStateProperty.all(Colors.brown),
                shape: MaterialStateProperty.all(const StadiumBorder())), */
            child: const Text(
              'No Tienes Cuenta ? Registrarse !!',
              style: TextStyle(
                  //color: Colors.black,
                  color: Color.fromRGBO(41, 60, 118, 10),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ) */
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormaProvider>(context);
    return Form(
        //TODO Mantener la referencia la KEY para validar los elementos del formulario al presionar el boton
        key: loginForm.formKey,
        //Dispara las validaciones
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            //--------------------
            //Email
            //--------------------
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'usuario',
                  labelText: 'Usuario',
                  prefixIcon: Icons.alternate_email_sharp),
              //Tomar os valores de las cajas de Texto
              onChanged: (value) => loginForm.email = value,
              //permite realizar validaciones
              validator: (value) {
                String pattern = r'^[a-zA-Z0-9]+$';
                /* r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'; */

                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'EL Valor ingreado no luce como un usuario o cedula';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            //--------------------
            //Contraseña
            //--------------------
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              //permite realizar validaciones
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'La contraseña debe de ser de 6 caarcteres ';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            //--------------------
            //Boton
            //--------------------
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromRGBO(41, 60, 118, 10),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        //quitar le teclado
                        FocusScope.of(context).unfocus();
                        //TODO Login form
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;
                        await Future.delayed(const Duration(seconds: 3));
                        //TODO Validar si el login es corrrecto
                        loginForm.isLoading = false;

                        final response =
                            await ValidaLoginServices.validarUsuario(
                                loginForm.email, loginForm.password);

                        final jsonData = await jsonDecode(response.body);
                        if (jsonData['codmsg'] == 200) {
                          // Almacenar el usuario en SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('user', loginForm.email);
                          // El login fue exitoso
                          //Permite acceder a la pantalla siguiente sin que permita regresar a la anaterior
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          // El login falló
                          // Mostrar un mensaje de error al usuario
                          const snackBar = SnackBar(
                            content: Text(
                                'El usuario o la contraseña no son correctos'),
                            duration: Duration(seconds: 2),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    //Cambiamos la descripcion en el boton cuando se ingresa
                    loginForm.isLoading ? 'Espere.....' : 'Ingresar',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }
}
