import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/widgets/Components-cards/resumen_compra.dart';
import 'package:pn_movil/widgets/Components-generales/estado_compra.dart';
import 'package:pn_movil/widgets/Components-generales/estado_flete.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class ComprasSolicitarDetalle extends StatelessWidget {
  const ComprasSolicitarDetalle({super.key});

  // Función para formatear un número a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }

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
                const SizedBox(height: 40),
                _buildTitle('Detalle de la Compra'),
                const SizedBox(height: 20),
                _buildDetailsCard(compra),
                const SizedBox(height: 20),
                _buildAdicionesSection(compra),
                const SizedBox(height: 20),
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Metodo para construir el título
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

  //Metodo para construir el detalle de la compra
  Widget _buildDetailsCard(Map<String, dynamic>? compra) {
    if (compra == null) {
      print('compra: $compra');
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }
    print('compra: $compra');
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
                value: compra['proveedor']['proveedor'] ?? 'Desconocida',
                iconColor: Colors.blue.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Monto:',
                value: formatCurrencyToCOP(compra['monto'] ?? 0),
                iconColor: Colors.orange.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Total a pagar:',
                value: formatCurrencyToCOP(compra['totalPagar'] ?? 0),
                iconColor: Colors.orange.shade700,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  estadoPagoWidget(compra['pago']),
                  SizedBox(width: 15),
                  estadoFleteWidget(compra['productoCompras'][0]['flete']),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Metodo para construir la sección de adiciones
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
          const SizedBox(height: 30),
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
                    '\$${(productoCompra['costo'] ?? 0).toStringAsFixed(0)}';
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
                Navigator.of(context).pushReplacementNamed('compras-solicitar');
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

  //Metodo para construir una fila de información
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
