import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/apiClient.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class FacturacionCrear extends StatefulWidget {
  const FacturacionCrear({super.key});

  @override
  State<FacturacionCrear> createState() => _FacturacionCrearState();
}

class _FacturacionCrearState extends State<FacturacionCrear> {
  late final FacturacionService pagoService;

  @override
  void initState() {
    super.initState();
    pagoService = FacturacionService(ApiClient('https://apppn.duckdns.org'));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? inventario =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título principal
            _buildTitle(),

            // Barra de búsqueda
            // _buildSearchBar(),

            // Contenido principal
            // _buildMainContent(),
          ],
        ),
      ),
    );
  }

  //Metodo para construir el título
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            color: Colors.blue.shade800,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'Crear facturación',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // Metodo para construir el contenido principal
}
