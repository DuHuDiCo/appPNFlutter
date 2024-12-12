import 'package:flutter/material.dart';
import 'package:pn_movil/providers/compra_provider.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-cards/cards_select_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
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

  int? _proveedorSeleccionado;
  bool _isFormValid = false;

//Funcion para inicializar el estado
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

//Funcion para liberar recursos
  @override
  void dispose() {
    _proveedorController.dispose();
    cantidadController.dispose();
    costoController.dispose();
    super.dispose();
  }

  // Agregar producto y actualizar estado
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

      checkFormValidity();
    });

    print("Productos seleccionados con detalles: $_selectedProducts");
  }

// Función para eliminar un producto seleccionado
  void removeProduct(String name, String clasification) {
    setState(() {
      _selectedProducts.removeWhere((product) =>
          product['productName'] == name &&
          product['clasification'] == clasification);

      checkFormValidity();
    });

    print("Productos seleccionados actualizados: $_selectedProducts");
  }

//Funcion para verificar si el producto seleccionado ya existe
  bool isProductSelected(String name, String clasification) {
    return _selectedProducts.any((product) =>
        product['productName'] == name &&
        product['clasification'] == clasification);
  }

//Funcion para verificar si el formulario es valido
  void checkFormValidity() {
    setState(() {
      _isFormValid = (_formKey.currentState?.validate() ?? false) &&
          _selectedProducts.isNotEmpty &&
          _proveedorSeleccionado != null;
    });
  }

//Funcion para guardar los datos del formulario
  void saveFormData() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Proveedor seleccionado: $_proveedorSeleccionado');
      print('Productos seleccionados: $_selectedProducts');

      Map<String, dynamic> nuevaCompra = {
        "monto": _calculoMonto(),
        "idProveedor": _proveedorSeleccionado,
        "productos": _selectedProducts.map((product) {
          return {
            "cantidad": int.parse(product['cantidad'] ?? '0'),
            "costo": double.parse(product['costo'] ?? '0'),
            "idProducto": product['productId'],
            "idUsuario": 1,
            "estimarFlete": bool.parse(product['estimarFlete'] ?? 'false'),
            "isDescuentoInicial":
                bool.parse(product['isDescuentoInicial'] ?? 'false'),
          };
        }).toList(),
        "totalCompra": _calculoTotalCompra(),
        "totalPagar": _calculoTotalPagar(),
      };

      Provider.of<CompraProvider>(context, listen: false)
          .createCompra(context, nuevaCompra);
    } else {
      print('Formulario no válido.');
    }
  }

//Funcion para calcular el monto total
  double _calculoMonto() {
    return _selectedProducts.fold(0.0, (previousValue, product) {
      return previousValue +
          (double.parse(product['costo'] ?? '0') *
              int.parse(product['cantidad'] ?? '0'));
    });
  }

//Funcion para calcular el total de compra
  double _calculoTotalCompra() {
    return _calculoMonto();
  }

//Funcion para calcular el total de pago
  double _calculoTotalPagar() {
    return _calculoMonto();
  }

//Funcion para crear el cuerpo del dialogo de agregar producto
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
                        onRemoveProduct: (name, clasification) {
                          removeProduct(name, clasification);
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

//Funcion para crear el header del dialogo de agregar producto
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
                    return DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _proveedorSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Proveedor compra',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _proveedorSeleccionado = value;
                        });
                        checkFormValidity();
                      },
                      items: proveedores.map((proveedor) {
                        return DropdownMenuItem<int>(
                          value: proveedor['idProveedor'],
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

// Función para crear el footer del dialogo de agregar producto
  Widget _buildFooter() {
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
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: (_isFormValid && _selectedProducts.isNotEmpty)
                  ? saveFormData
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Registrar',
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

//Dialogo para agregar producto
  Future<void> _showAddProductDialog(BuildContext context, String productName,
      String clasification, String productId) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController costoController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Agregar Producto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cantidadController,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.shopping_cart),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: costoController,
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 129, 121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                  child: const Text(
                    'Agregar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
