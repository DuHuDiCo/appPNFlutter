import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/providers/products_sin_facturacion_provider.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class ProductSinFacturacion extends StatelessWidget {
  const ProductSinFacturacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título principal
            _buildTitle(),

            // Barra de búsqueda
            _buildSearchBar(context),

            // Contenido principal
            _buildMainContent(context),
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
        'Explora los Productos sin facturación',
        style: TextStyle(
          fontSize: 21,
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
                hintText: 'Buscar productos sin facturación...',
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

  ///Metodo para construir el contenido principal
  Widget _buildMainContent(BuildContext context) {
    Future.microtask(() => context
        .read<ProductsSinFacturacionProvider>()
        .loadProductosSinFacturacion(context));

    return Consumer<ProductsSinFacturacionProvider>(
      builder: (context, productosSinFacturacionProvider, child) {
        if (productosSinFacturacionProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (productosSinFacturacionProvider.productosSinFacturacion.isEmpty) {
          return const Center(
            child: Text(
              'No hay facturas disponibles.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount:
                productosSinFacturacionProvider.productosSinFacturacion.length,
            itemBuilder: (context, index) {
              final productoSinFacturacion = productosSinFacturacionProvider
                  .productosSinFacturacion[index];

              return ListItem(
                imageUrl: (productoSinFacturacion['productoCompra']['producto']
                            ['imagenes'] is List &&
                        productoSinFacturacion['productoCompra']['producto']
                                ['imagenes']
                            .isNotEmpty)
                    ? productoSinFacturacion['productoCompra']['producto']
                        ['imagenes'][0]['urlPath']
                    : 'assets/algo.jpg',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productoSinFacturacion['productoCompra']['producto']
                              ['producto'] ??
                          'Producto sin nombre',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${productoSinFacturacion['productoCompra']['producto']['clasificacionProducto']['clasificacionProducto'] ?? 'Clasificación no disponible'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cantidad: ${productoSinFacturacion['productoCompra']['cantidad']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Inventario # ${productoSinFacturacion['inventory']['idInventory']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(productoSinFacturacion['inventory']['dateInventory']))}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        'facturacion-crear',
                        arguments: productoSinFacturacion['inventory'],
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(112, 185, 244, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Facturar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
