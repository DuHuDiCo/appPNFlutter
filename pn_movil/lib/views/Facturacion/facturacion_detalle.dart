import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/resumen_compra.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class FacturacionDetalle extends StatefulWidget {
  const FacturacionDetalle({super.key});

  @override
  State<FacturacionDetalle> createState() => _FacturacionDetalleState();
}

class _FacturacionDetalleState extends State<FacturacionDetalle> {
  late final FacturacionService facturacionService;

  @override
  void initState() {
    super.initState();
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FacturacionProvider>().loadFacturas(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? factura =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTitle(),
            _buildDetailsCard(factura),
            const SizedBox(height: 40),
            _buildAdicionesSection(factura),
            const SizedBox(height: 40),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  ///Metoodo para construir el título de la pantalla
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(
          'Detalle del inventario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///Metodo para construir la tarjeta con los detalles del inventario
  Widget _buildDetailsCard(Map<String, dynamic>? factura) {
    if (factura == null) {
      return const Center(
        child: Text('No se pudo cargar la información del inventario.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: Icons.person,
                title: 'Facturacion #',
                value: '${factura['idFacturacion'] ?? 0}',
                iconColor: Colors.blue.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.calendar_today,
                title: 'Fecha:',
                value: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(factura['fecha'])),
                iconColor: Colors.grey.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Total facturacion:',
                value: facturacionService
                    .formatCurrencyToCOP(factura["totalFacturacion"]),
                iconColor: Colors.orange.shade700,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  //Metodo para construir la sección de productos del inventario
  Widget _buildAdicionesSection(Map<String, dynamic>? factura) {
    if (factura == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    List<dynamic> productosFacturados =
        factura['productoCompraFacturacion'] ?? {};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Productos del inventario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productosFacturados.length,
              itemBuilder: (context, index) {
                final producto = productosFacturados[index];
                final productoCompraInventory =
                    producto['productoCompraInventory'] ?? {};

                final List<dynamic> imagenes =
                    productoCompraInventory['productoCompra']['imagenes'] ?? [];
                final String imageUrl =
                    imagenes.isNotEmpty ? imagenes[0]['urlPath'] : '';

                final String productoName =
                    productoCompraInventory['productoCompra']['producto']
                            ['producto'] ??
                        'Producto desconocido';

                final String clasificacion =
                    productoCompraInventory['productoCompra']['producto']
                                ['clasificacionProducto']
                            ?['clasificacionProducto'] ??
                        'Sin clasificación';

                final String price = facturacionService.formatCurrencyToCOP(
                    productoCompraInventory['productoCompra']['costo']);
                final String units =
                    '${productoCompraInventory['productoCompra']['cantidad'] ?? 0} unidad${(producto['cantidad'] ?? 0) > 1 ? 'es' : ''}';

                return Container(
                  width: 190,
                  height: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ProductCard(
                    imageUrl: imageUrl,
                    productName: productoName,
                    price: price,
                    units: units,
                    additionalInfo: clasificacion,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para crear el footer del dialogo de agregar producto
  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('facturacion');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: const Text(
                'Regresar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  ///Metodo para construir una fila de información con un icono, título y valor
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }
}
