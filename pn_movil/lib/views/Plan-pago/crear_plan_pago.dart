import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class CrearPlanPago extends StatelessWidget {
  const CrearPlanPago({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('CrearPlanPago'),
      ),
    );
  }
}
