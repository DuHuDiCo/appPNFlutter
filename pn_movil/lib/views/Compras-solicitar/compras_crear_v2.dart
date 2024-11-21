import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/botton_CP.dart';
import 'package:pn_movil/widgets/card_container.dart';
import 'package:pn_movil/widgets/cards_select_products.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class SeleccionarProductos extends StatefulWidget {
  const SeleccionarProductos({super.key});

  @override
  _SeleccionarProductosState createState() => _SeleccionarProductosState();
}

class _SeleccionarProductosState extends State<SeleccionarProductos> {
  final List<Map<String, String>> _selectedProducts = [];

  void _addProduct(String name, String price, String units) {
    setState(() {
      _selectedProducts.add({
        'productName': name,
        'price': price,
        'units': units,
      });
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
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: CardContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
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
                                borderRadius: BorderRadius.circular(
                                    8), // Borde redondeado
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
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    ProductCardSelect(
                      imageUrl: 'assets/algo.jpg',
                      productName: 'Adidas talla 32',
                      price: '100',
                      units: '10',
                      onAddProduct: _addProduct,
                    ),
                    ProductCardSelect(
                      imageUrl: 'assets/algo.jpg',
                      productName: 'Adidas talla 32',
                      price: '100',
                      units: '10',
                      onAddProduct: _addProduct,
                    ),
                    ProductCardSelect(
                      imageUrl: 'assets/algo.jpg',
                      productName: 'Nike talla 40',
                      price: '150',
                      units: '5',
                      onAddProduct: _addProduct,
                    ),
                    ProductCardSelect(
                      imageUrl: 'assets/algo.jpg',
                      productName: 'Puma talla 36',
                      price: '120',
                      units: '7',
                      onAddProduct: _addProduct,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
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
                      child: const Text(
                        'Total: 0',
                        style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}
