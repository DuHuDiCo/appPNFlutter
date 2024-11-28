import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class ComprasSolicitarEditar extends StatelessWidget {
  const ComprasSolicitarEditar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('ComprasSolicitarEditar'),
      ),
    );
  }
}
