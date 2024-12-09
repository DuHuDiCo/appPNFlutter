import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';
import 'package:pn_movil/providers/inventario_provider.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-cards/resumen_compra.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/services/inventario_service.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class DetalleInventario extends StatefulWidget {
  const DetalleInventario({super.key});

  @override
  State<DetalleInventario> createState() => _DetalleInventarioState();
}

class _DetalleInventarioState extends State<DetalleInventario> {
  late final InventarioService inventarioService;

  bool selectedIsNull = false;

  @override
  void initState() {
    super.initState();
    inventarioService =
        InventarioService(ApiClient('https://apppn.duckdns.org'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<InventarioProvider>()
          .loadInventarios(context, isNull: selectedIsNull == true);
    });
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
            _buildTitle(),
            _buildDetailsCard(inventario, context.read<InventarioProvider>()),
            const SizedBox(height: 40),
            _buildAdicionesSection(inventario),
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
  Widget _buildDetailsCard(
      Map<String, dynamic>? inventario, inventarioProvider) {
    final totalPorInventario =
        inventarioProvider.calcularTotalPorInventario(inventario);

    if (inventario == null) {
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
                icon: Icons.calendar_today,
                title: 'Fecha:',
                value: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(inventario['dateInventory'])),
                iconColor: Colors.grey.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.person,
                title: 'Cantidad general:',
                value: '${inventario['quantity'] ?? 0}',
                iconColor: Colors.blue.shade700,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                icon: Icons.monetization_on,
                title: 'Total:',
                value:
                    inventarioService.formatCurrencyToCOP(totalPorInventario),
                iconColor: Colors.orange.shade700,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.money,
                      color: Color.fromARGB(255, 129, 173, 86)),
                  const SizedBox(width: 8),
                  facturacionWidget(inventario['facturacion']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Metodo para construir la sección de productos del inventario
  Widget _buildAdicionesSection(Map<String, dynamic>? inventario) {
    if (inventario == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    List<dynamic> productos = inventario['productoCompras'] ?? [];

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
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final productoCompra = productos[index];
                final producto =
                    productoCompra['productoCompra']['producto'] ?? {};

                final List<dynamic> imagenes = producto['imagenes'] ?? [];
                final String imageUrl =
                    imagenes.isNotEmpty ? imagenes[0]['urlPath'] : '';

                final String productoName =
                    producto['producto'] ?? 'Producto desconocido';

                final String clasificacion = producto['clasificacionProducto']
                        ?['clasificacionProducto'] ??
                    'Sin clasificación';

                final String price = inventarioService.formatCurrencyToCOP(
                    productoCompra['productoCompra']['costo']);
                final String units =
                    '${productoCompra['productoCompra']['cantidad'] ?? 0} unidad${(producto['cantidad'] ?? 0) > 1 ? 'es' : ''}';

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

  //Metodo que muestra si la facturación es null o no
  Widget facturacionWidget(dynamic facturacion) {
    Color backgroundColor;
    Color textColor;
    String facturacionTexto;
    IconData icon;

    if (facturacion == null) {
      backgroundColor = const Color.fromARGB(255, 226, 85, 70);
      textColor = Colors.white;
      facturacionTexto = 'Sin facturación';
      icon = Icons.block;
    } else {
      backgroundColor = const Color.fromARGB(255, 111, 190, 114);
      textColor = Colors.white;
      facturacionTexto = 'Con facturación';
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            facturacionTexto,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
