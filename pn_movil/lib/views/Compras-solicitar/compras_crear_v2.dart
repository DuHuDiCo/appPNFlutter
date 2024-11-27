import 'package:flutter/material.dart';
import 'package:pn_movil/providers/compra_provider.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _proveedorController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController costoController = TextEditingController();
  final List<Map<String, String>> _selectedProducts = [];

  String? _proveedorSeleccionado;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProveedorProvider>(context, listen: false)
          .loadProveedores(context);
      Provider.of<ProductsProvider>(context, listen: false)
          .loadProducts(context);
    });
  }

  @override
  void dispose() {
    _proveedorController.dispose();
    cantidadController.dispose();
    costoController.dispose();
    super.dispose();
  }

  void _addProductWithDetails(String name, String clasification, int cantidad,
      double costo, String productId) {
    if (_selectedProducts.any((product) =>
        product['productName'] == name &&
        product['clasification'] == clasification)) {
      return;
    }
    setState(() {
      _selectedProducts.add({
        'productName': name,
        'clasification': clasification,
        'cantidad': cantidad.toString(),
        'costo': costo.toString(),
        'productId': productId,
      });
    });
    print("Productos seleccionados con detalles: $_selectedProducts");
  }

  void checkFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void saveFormData() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Proveedor seleccionado: $_proveedorSeleccionado');
      print('Productos seleccionados: $_selectedProducts');

      // Generar el objeto de la compra
      Map<String, dynamic> nuevaCompra = {
        "monto": _calculateMonto(),
        "idProveedor": 6,
        "productos": _selectedProducts.map((product) {
          return {
            "cantidad": int.parse(product['cantidad'] ?? '0'),
            "costo": double.parse(product['costo'] ?? '0'),
            "idProducto": product['productId'],
            "idUsuario": 1,
            "estimarFlete": true,
            "isDescuentoInicial": true,
          };
        }).toList(),
        "totalCompra": _calculateTotalCompra(),
        "totalPagar": _calculateTotalPagar(),
      };

      Provider.of<CompraProvider>(context, listen: false)
          .createCompra(context, nuevaCompra);
    } else {
      print('Formulario no válido.');
    }
  }

  double _calculateMonto() {
    return _selectedProducts.fold(0.0, (previousValue, product) {
      return previousValue +
          (double.parse(product['precio'] ?? '0') *
              int.parse(product['cantidad'] ?? '0'));
    });
  }

  double _calculateTotalCompra() {
    return _calculateMonto();
  }

  double _calculateTotalPagar() {
    return _calculateMonto();
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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.products.isEmpty) {
                    return const Center(
                        child: Text('No hay productos disponibles'));
                  }

                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: provider.products.map((product) {
                      bool isSelected = isProductSelected(
                          product['producto'],
                          product['clasificacionProducto']
                              ['clasificacionProducto']);
                      return ProductCardSelect(
                        imageUrl: (product['imagenes'] is List &&
                                product['imagenes'].isNotEmpty)
                            ? product['imagenes'][0]['urlPath']
                            : 'assets/algo.jpg',
                        productName:
                            product['producto'] ?? 'Producto sin nombre',
                        clasification: product['clasificacionProducto']
                            ['clasificacionProducto'],
                        onAddProduct: (productName, clasification, productId) {
                          _showAddProductDialog(
                              context, productName, clasification, productId);
                        },
                        isSelected: isSelected,
                        productId: product['idProducto'].toString(),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildFooter(),
            ],
          ),
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
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
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
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Consumer<ProveedorProvider>(
                  builder: (context, proveedorProvider, child) {
                    if (proveedorProvider.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    final proveedores = proveedorProvider.proveedores;
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _proveedorSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Proveedor compra',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _proveedorSeleccionado = value;
                        });
                        checkFormValidity();
                      },
                      items: proveedores.map((proveedor) {
                        return DropdownMenuItem<String>(
                          value: proveedor['proveedor'],
                          child: Text(proveedor['proveedor']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
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

  bool isProductSelected(String name, String clasification) {
    return _selectedProducts.any((product) =>
        product['productName'] == name &&
        product['clasification'] == clasification);
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _isFormValid ? saveFormData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Agregar productos',
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

  Future<void> _showAddProductDialog(BuildContext context, String productName,
      String clasification, String productId) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController costoController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar $productName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: costoController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (cantidadController.text.isNotEmpty &&
                    costoController.text.isNotEmpty) {
                  _addProductWithDetails(
                    productName,
                    clasification,
                    int.parse(cantidadController.text),
                    double.parse(costoController.text),
                    productId,
                  );
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
