import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class Facturacion extends StatefulWidget {
  const Facturacion({super.key});

  @override
  _FacturacionState createState() => _FacturacionState();
}

class _FacturacionState extends State<Facturacion> {
  late final FacturacionService facturacionService;

  @override
  void initState() {
    super.initState();
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));
  }

  @override
  Widget build(BuildContext context) {
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
            _buildSearchBar(context),

            // Contenido principal
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  //Metodo para construir el título
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Explora nuestras facturaciones',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Metodo que construye la barra de búsqueda
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar facturaciones...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 175, 177, 178),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 175, 177, 178),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    Future.microtask(
        () => context.read<FacturacionProvider>().loadFacturas(context));

    return Consumer<FacturacionProvider>(
      builder: (context, facturaProvider, child) {
        if (facturaProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (facturaProvider.facturas.isEmpty) {
          return const Center(
            child: Text(
              'No hay facturas disponibles.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: facturaProvider.facturas.length,
            itemBuilder: (context, index) {
              final factura = facturaProvider.facturas[index];

              return ListItem(
                imageUrl: null,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Factura #${factura['idFacturacion']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(factura['fecha']))}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total facturación: ${facturacionService.formatCurrencyToCOP(factura["totalFacturacion"])}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón redondo
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(112, 185, 244, 1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            'productos-facturacion-detalle',
                            arguments: factura,
                          );
                        },
                        icon: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                        tooltip: 'Ver detalles',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
