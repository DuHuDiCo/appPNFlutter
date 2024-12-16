import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class FacturacionDetalle extends StatelessWidget {
  const FacturacionDetalle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('FacturacionDetalle'),
      ),
    );
  }
}
