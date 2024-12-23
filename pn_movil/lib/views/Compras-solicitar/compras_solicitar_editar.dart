import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-cards/cards_edit_products.dart';
import 'package:pn_movil/widgets/Components-cards/cards_select_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class ComprasSolicitarEditar extends StatefulWidget {
  const ComprasSolicitarEditar({super.key});

  @override
  _ComprasSolicitarEditarState createState() => _ComprasSolicitarEditarState();
}

class _ComprasSolicitarEditarState extends State<ComprasSolicitarEditar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? proveedorSeleccionado = 0;
  bool loadingProductos = false;
  final List<Map<String, String>> _selectedProducts = [];
  final Map<String, dynamic> _productosBackend = {
    "monto": 0,
    "idProveedor": 0,
    "productos": [],
    "totalCompra": 0,
    "totalPagar": 0
  };

  List<Map<String, dynamic>> productos = [];
  Map<String, dynamic> compra = {};
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

  var logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    compra = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    if (compra['productoCompras'] is List) {
      productos = (compra['productoCompras'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();

      // Llenar el array de productos en _productosBackend
      _productosBackend["productos"] = productos.map((product) {
        return {
          "cantidad": product["cantidad"]!,
          "costo": product["costo"]!,
          "idProducto": product["producto"]["idProducto"]!,
          "idUsuario": product["user"]["idUser"]!,
        };
      }).toList();
    }

    if (compra != null) {
      // TRAER EL ID DEL PROVEEDOR
      setState(() {
        proveedorSeleccionado = compra['proveedor']['idProveedor'];
      });
    }
  }

//Funcion para crear el cuerpo del dialogo de agregar producto
  @override
  Widget build(BuildContext context) {
    print(proveedorSeleccionado);
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: loadingProductos
                        ? provider.products.map((product) {
                            bool isSelected =
                                isProductSelected(product['idProducto']);
                            return ProductCardSelect(
                              imageUrl: (product['imagenes'] is List &&
                                      product['imagenes'].isNotEmpty)
                                  ? product['imagenes'][0]['urlPath']
                                  : 'assets/algo.jpg',
                              productName:
                                  product['producto'] ?? 'Producto sin nombre',
                              clasification: product['clasificacionProducto']
                                  ['clasificacionProducto'],
                              onAddProduct:
                                  (productName, clasification, productId) {
                                _showEditProductDialog(
                                    context,
                                    productName,
                                    clasification,
                                    0,
                                    0,
                                    product['idProducto'],
                                    product['productosCompras'][0]['user']
                                        ['idUser'],
                                    false);
                              },
                              onRemoveProduct: (name, clasification) {},
                              isSelected: isSelected,
                              productId: product['idProducto'].toString(),
                              isEdit: true,
                            );
                          }).toList()
                        : productos.map((product) {
                            return ProductCardEdit(
                              imageUrl: (product['imagenes'] is List &&
                                      product['imagenes'].isNotEmpty)
                                  ? product['imagenes'][0]['urlPath']
                                  : 'assets/algo.jpg',
                              productName: product['producto']['producto'] ??
                                  'Producto sin nombre',
                              clasification: product['producto']
                                      ['clasificacionProducto']
                                  ['clasificacionProducto'],
                              onEditProduct:
                                  (productName, cantidad, precio, productId) {
                                _showEditProductDialog(
                                    context,
                                    productName,
                                    '',
                                    cantidad,
                                    precio,
                                    productId,
                                    product['user']['idUser'],
                                    true);
                              },
                              onRemoveProduct: (name, idProductoCompra) {
                                eliminarProducto(
                                    context,
                                    product['idProductoCompra'],
                                    product['producto']['idProducto']);
                              },
                              productId: product['producto']['idProducto'],
                              cantidad: product['cantidad'],
                              precio: product['costo'],
                              productIdCompra: product['idProductoCompra'],
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
                      'Editar Compra',
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
                      // value: _proveedorSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Proveedor compra',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          proveedorSeleccionado = newValue;
                        });
                      },
                      value: proveedorSeleccionado,
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
                        const SizedBox(width: 8),
                        Text(
                          loadingProductos
                              ? 'Agregar Productos'
                              : 'Mis Productos',
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
                        onPressed: () async {
                          setState(() {
                            loadingProductos = loadingProductos ? false : true;
                          });
                        },
                        icon: Icon(
                          loadingProductos ? Icons.arrow_back : Icons.add,
                        ),
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

  //Dialogo para editar producto
  Future<void> _showEditProductDialog(
      BuildContext context,
      String productName,
      String clasification,
      int cantidad,
      double precio,
      int productId,
      int userId,
      bool isEdit) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController costoController = TextEditingController();

    // Inicializamos los valores de los campos
    if (cantidad != 0 && precio != 0) {
      cantidadController.text = cantidad.toString();
      costoController.text = precio.toStringAsFixed(2);
    }

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
                isEdit ? 'Editar Producto' : 'Agregar Producto',
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
                    if (isEdit) {
                      // Obtenemos los valores del formulario
                      final nuevaCantidad =
                          int.tryParse(cantidadController.text) ?? cantidad;
                      final nuevoPrecio =
                          double.tryParse(costoController.text) ?? precio;

                      // Buscamos el producto en la lista y actualizamos
                      final productoIndex = productos.indexWhere((producto) =>
                          producto['producto']['idProducto'] == productId);

                      final productBack = _productosBackend['productos']
                          .indexWhere((producto) =>
                              producto['idProducto'] == productId);

                      if (productoIndex != -1) {
                        setState(() {
                          productos[productoIndex]['cantidad'] = nuevaCantidad;
                          productos[productoIndex]['costo'] = nuevoPrecio;

                          _productosBackend['productos'][productBack]
                              ['cantidad'] = nuevaCantidad;
                          _productosBackend['productos'][productBack]['costo'] =
                              nuevoPrecio;
                        });
                      }
                    } else {
                      if (cantidadController.text.isNotEmpty &&
                          costoController.text.isNotEmpty) {
                        _addProductWithDetails(
                          productName,
                          clasification,
                          int.parse(cantidadController.text),
                          double.parse(costoController.text),
                          productId.toString(),
                          userId,
                        );
                        Navigator.of(context).pop(true);
                      }
                    }
                    logger.i(JsonEncoder.withIndent('  ')
                        .convert(productos[productos.length - 1]));
                    // Navigator.of(context).pop(true);
                  },
                  child: Text(
                    isEdit ? 'Actualizar' : 'Agregar',
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

  void eliminarProducto(
      BuildContext context, int idProductoCompra, int idProducto) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar producto"),
          content: const Text("¿Está seguro que desea eliminar el producto?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  compra['productoCompras'].removeWhere((product) =>
                      product['idProductoCompra'] == idProductoCompra);

                  List<Map<String, dynamic>> productos =
                      _productosBackend['productos'];
                  productos.removeWhere(
                      (product) => product['idProducto'] == idProducto);
                });

                print(
                    'Productos eliminados: ${_productosBackend['productos']}');

                Navigator.of(dialogContext).pop(); // Cierra el diálogo

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Producto eliminado exitosamente"),
                  ),
                );
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

  //Boton para guardar los datos del formulario
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Editar compra',
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

  // Agregar producto y actualizar estado
  void _addProductWithDetails(String name, String clasification, int cantidad,
      double costo, String productId, int userId) {
    setState(() {
      productos.add({
        'idProductoCompra': '',
        'cantidad': cantidad.toString(),
        'costo': costo.toString(),
        'flete': '0.0',
        'producto': {
          'idProducto': productId,
          'producto': name,
          'descripcion': '',
          'imagenes': [],
          'clasificacionProducto': {
            'idClasificacionProducto': '',
            'clasificacionProducto': clasification,
            'isFleteObligatorio': false,
          },
          'productosCompras': []
        }
      });

      _productosBackend['productos'].add({
        'cantidad': cantidad,
        'costo': costo,
        'productId': productId,
        'usuarioId': userId,
      });

      checkFormValidity();
    });
  }

  //Funcion para verificar si el formulario es valido
  void checkFormValidity() {
    setState(() {
      _isFormValid = (_formKey.currentState?.validate() ?? false) &&
          _selectedProducts.isNotEmpty;
    });
  }

  //Funcion para verificar si el producto seleccionado ya existe
  bool isProductSelected(int idProducto) {
    return _productosBackend['productos'].any((product) {
      var id = product['idProducto'];
      return id == idProducto;
    });
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
}
