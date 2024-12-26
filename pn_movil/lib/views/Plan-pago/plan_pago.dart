import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class PlanPago extends StatefulWidget {
  const PlanPago({super.key});

  @override
  _PlanPagoState createState() => _PlanPagoState();
}

class _PlanPagoState extends State<PlanPago> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título principal
            // _buildTitle(),

            // Barra de búsqueda
            // _buildSearchBar(),

            // Contenido principal
          ],
        ),
      ),
    );
  }
}
