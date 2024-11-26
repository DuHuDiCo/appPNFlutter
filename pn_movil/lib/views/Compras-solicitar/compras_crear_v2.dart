import 'package:flutter/material.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/widgets/botton_CP.dart';
import 'package:pn_movil/widgets/card_container.dart';
import 'package:pn_movil/widgets/cards_select_products.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';
import 'package:provider/provider.dart';

class SeleccionarProductos extends StatefulWidget {
  const SeleccionarProductos({super.key});

  @override
  _SeleccionarProductosState createState() => _SeleccionarProductosState();
}

class _SeleccionarProductosState extends State<SeleccionarProductos> {
  final List<Map<String, String>> _selectedProducts = [];

  void _addProduct(String name, String clasification) {
    setState(() {
      _selectedProducts.add({
        'productName': name,
        'clasification': clasification,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false)
          .loadProducts(context);
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
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.products.isEmpty) {
              return const Center(child: Text('No hay productos disponibles'));
            }

            return ListView(
              padding: const EdgeInsets.all(1),
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: provider.products.map((product) {
                      return ProductCardSelect(
                        imageUrl: (product['imagenes'] is List &&
                                product['imagenes'].isNotEmpty)
                            ? product['imagenes'][0]['urlPath']
                            : 'assets/algo.jpg',
                        productName:
                            product['producto'] ?? 'Producto sin nombre',
                        clasification: product['clasificacionProducto']
                            ['clasificacionProducto'],
                        onAddProduct: (name, clasification) {
                          _addProduct(name, clasification);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),
                _buildFooter(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: CardContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.blue.shade800,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Registrar Compra',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CustomToggleButton(),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue.shade800,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Agregar Productos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(112, 185, 244, 1),
                        borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 12, 12, 12),
              ),
              child: Text(
                'Total: ${_selectedProducts.length}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 244, 245, 246),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () {
                // Acción del botón Guardar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Color.fromARGB(255, 244, 245, 246),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
