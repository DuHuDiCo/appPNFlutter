import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/cards_listar_products.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar el paquete provider

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(
        () => context.read<ProductsProvider>().loadProducts(context));

    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<ProductsProvider>(
          builder: (context, productsProvider, child) {
            if (productsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (productsProvider.products.isEmpty) {
              return const Center(child: Text('No hay productos disponibles'));
            } else {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Explora nuestros productos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar productos...',
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(112, 185, 244, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, 'crearProduct');
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mostrar los productos
                  ...productsProvider.products.map((product) {
                    return ListItem(
                      imageUrl: product['imagenes'].isNotEmpty
                          ? product['imagenes'][0]
                          : 'assets/algo.jpg', // Imagen por defecto si está vacía
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['producto'] ?? 'Producto sin nombre',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product['descripcion'] ??
                                'Descripción no disponible',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Categoría: ${product['clasificacionProducto']['clasificacionProducto']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'crearProduct');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(112, 185, 244, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
