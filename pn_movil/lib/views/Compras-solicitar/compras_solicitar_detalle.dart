import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/widgets/Components-cards/resumen_compra.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class ComprasSolicitarDetalle extends StatelessWidget {
  const ComprasSolicitarDetalle({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? compra =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTitle('Detalle de la Compra'),
                const SizedBox(height: 30),
                _buildDetailsCard(compra),
                const SizedBox(height: 30),
                _buildAdicionesSection(compra),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic>? compra) {
    if (compra == null) {
      print('compra: $compra');
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }
    print('compra: $compra');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                title: 'Fecha:',
                value: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(compra['fecha'])),
                iconColor: Colors.grey.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.person,
                title: 'Proveedor:',
                value: compra['idProveedor'] ?? 'Desconocida',
                iconColor: Colors.blue.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Monto:',
                value: '\$${(compra['monto'] ?? 0).toStringAsFixed(2)}',
                iconColor: Colors.orange.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Total a pagar:',
                value: '\$${(compra['totalPagar'] ?? 0).toStringAsFixed(2)}',
                iconColor: Colors.orange.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdicionesSection(Map<String, dynamic>? compra) {
    if (compra == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    List<dynamic> productos = compra['productoCompras'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Productos agregados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final productoCompra = productos[index];
                final producto = productoCompra['producto'] ?? {};

                final List<dynamic> imagenes = producto['imagenes'] ?? [];
                final String imageUrl =
                    imagenes.isNotEmpty ? imagenes[0]['urlPath'] : '';

                final String productoName =
                    producto['producto'] ?? 'Producto desconocido';

                final String clasificacion = producto['clasificacionProducto']
                        ?['clasificacionProducto'] ??
                    'Sin clasificación';

                final String price =
                    '\$${(productoCompra['costo'] ?? 0).toStringAsFixed(2)}';
                final String units =
                    '${productoCompra['cantidad'] ?? 0} unidad${(productoCompra['cantidad'] ?? 0) > 1 ? 'es' : ''}';

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
