import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/pago_cliente_provider.dart';
import 'package:pn_movil/services/pago_cliente_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class PagosClientesSinaplicar extends StatefulWidget {
  const PagosClientesSinaplicar({super.key});

  @override
  _PagosClientesSinaplicarState createState() =>
      _PagosClientesSinaplicarState();
}

class _PagosClientesSinaplicarState extends State<PagosClientesSinaplicar> {
  late final PagoClienteService pagoClienteService;

  @override
  void initState() {
    super.initState();
    pagoClienteService =
        PagoClienteService(ApiClient('https://apppn.duckdns.org'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<PagoClienteProvider>(context, listen: false)
            .obtenerPagosSinAplicar(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
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

  // Método para construir el título
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Explora nuestros pagos de clientes sin aplicar',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Método para construir el título de la barra de búsqueda
}
