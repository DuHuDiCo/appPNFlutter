import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class VistaInicial extends StatelessWidget {
  const VistaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          'Bienvenido',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
