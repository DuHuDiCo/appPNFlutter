import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/cards_listar_products.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<ProductsProvider>().loadProducts(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
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
          } else {
            return _buildProductsList(productsProvider.products);
          }
        },
      ),
    );
  }

  Widget _buildProductsList(List<Map<String, dynamic>> products) {
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
        _buildSearchBar(),
        const SizedBox(height: 16),
        ...products.map((product) => _buildProductItem(product)).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                Navigator.pushReplacementNamed(context, 'crearProduct');
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return ListItem(
      imageUrl: (product['imagenes'] is List && product['imagenes'].isNotEmpty)
          ? product['imagenes'][0]['urlPath']
          : 'assets/algo.jpg',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product['producto'] ?? 'Producto sin nombre',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            product['descripcion'] ?? 'Descripción no disponible',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            'Categoría: ${product['clasificacionProducto']['clasificacionProducto']}',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'crearProduct');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(112, 185, 244, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            final provider =
                Provider.of<ProductsProvider>(context, listen: false);
            final productId = product['idProducto'];
            if (productId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('El producto no tiene un ID válido')),
              );
              return;
            }
            eliminarProducto(context, productId, provider);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 238, 117, 101),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void eliminarProducto(
      BuildContext context, int productId, ProductsProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Usamos dialogContext en el builder
        return AlertDialog(
          title: const Text("Eliminar producto"),
          content: const Text("¿Está seguro que desea eliminar el producto?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerramos el diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext)
                    .pop(); // Cerramos el diálogo primero

                try {
                  await provider.deleteProduct(context, productId);
                  // Mostramos un SnackBar usando el contexto principal
                  Future.delayed(Duration.zero, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto eliminado exitosamente'),
                      ),
                    );
                  });
                } catch (e) {
                  Future.delayed(Duration.zero, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  });
                }
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
