import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.lightGreenAccent,
      width: double.infinity,
      height: double.infinity,
      //el Stack coloca widgets uno encima de otro
      child: Stack(
        children: <Widget>[
          const _PurpleBox(),
          //implementacion del icono grande en la parte superio del login
          _contenedorIcono(),
          //este es el constructor
          child
        ],
      ),
    );
  }

  SafeArea _contenedorIcono() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          /* Icons.person_pin, */
          Icons.local_parking_outlined,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

//este sera el contenedor Morado que viene en el Login
class _PurpleBox extends StatelessWidget {
  const _PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      //color: Colors.indigo,
      //Fondo de el cuadrado superior
      decoration: _purpleBuckground(),
      //diseño de las pelotitas de fondo
      child: Stack(
        children: [
          Positioned(
            top: 90,
            left: 30,
            child: _Bubble(),
          ),
          Positioned(
            top: -40,
            left: -30,
            child: _Bubble(),
          ),
          Positioned(
            top: -50,
            right: -30,
            child: _Bubble(),
          ),
          Positioned(
            bottom: -50,
            left: 10,
            child: _Bubble(),
          ),
          Positioned(
            bottom: 120,
            right: 20,
            child: _Bubble(),
          )
        ],
      ),
    );
  }

  BoxDecoration _purpleBuckground() {
    return const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromARGB(255, 5, 48, 83),
      Color.fromARGB(255, 4, 52, 92)
      /* Color.fromRGBO(63, 63, 156, 1),
      Color.fromRGBO(90, 70, 178, 1) */
    ]));
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          /* color: const Color.fromRGBO(255, 255, 255, 0.5) */
          color: const Color.fromARGB(150, 247, 243, 243)),
    );
  }
}
