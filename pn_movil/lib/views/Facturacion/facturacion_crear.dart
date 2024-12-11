import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/cards_edit_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class FacturacionCrear extends StatefulWidget {
  const FacturacionCrear({super.key});

  @override
  State<FacturacionCrear> createState() => _FacturacionCrearState();
}

class _FacturacionCrearState extends State<FacturacionCrear> {
  late final FacturacionService facturacionService;
  List<Map<String, dynamic>> productosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientesProvider>(context, listen: false)
          .loadClientes(context);
    });
  }

  void _addProductWithDetails(String name, String clasification, int cantidad,
      double valorVenta, String productId, int clientId, double descuento) {
    if (productosSeleccionados.any((product) =>
        product['productName'] == name &&
        product['clasification'] == clasification)) {
      return;
    }

    setState(() {
      facturacionService.addProducts({
        'cantidad': cantidad.toString(),
        'idCliente': clientId.toString(),
        'valorVenta': valorVenta.toString(),
        'descuentoPagoInicial': descuento.toString(),
        'idProductoCompra': productId,
      });
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
            // Título principal
            _buildTitle(),

            // Contenido principal
            _buildMainContent(inventario),

            // Botón para guardar la facturación
            _buildFooter(inventario),
          ],
        ),
      ),
    );
  }

  //Metodo para construir el título
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            color: Colors.blue.shade800,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'Crear facturación',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  //Meotodo para construir
  Widget _buildMainContent(Map<String, dynamic>? inventario) {
    if (inventario == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    List<dynamic> productos = inventario['productoCompras'] ?? [];

    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap:
                    true, // Hace que el GridView use solo el espacio necesario
                physics:
                    NeverScrollableScrollPhysics(), // Desactiva el scroll interno
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.6,
                ),
                itemCount: productos.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productos[index];
                  final productData = product['productoCompra'] ?? {};
                  final producto = productData['producto'] ?? {};
                  bool isSelected = facturacionService.isProductSelected(
                    productData['idProductoCompra'],
                  );
                  print(isSelected);
                  return ProductCardSelect(
                    imageUrl: (producto['imagenes'] is List &&
                            producto['imagenes'].isNotEmpty)
                        ? producto['imagenes'][0]['urlPath']
                        : 'assets/algo.jpg',
                    productName: producto['producto'] ?? 'Producto sin nombre',
                    clasification: producto['clasificacionProducto']
                            ?['clasificacionProducto'] ??
                        'Sin clasificar',
                    // cantidad: inventario['quantity'],
                    onAddProduct: (productName, clasification, productId) {
                      _showAddProductDialog(
                          context, productName, clasification, productId);
                    },
                    onRemoveProduct: (name, clasification) {
                      setState(() {
                        facturacionService
                            .removeProduct(productData['idProductoCompra']);
                      });
                    },
                    isSelected: isSelected,
                    productId:
                        productData['idProductoCompra']?.toString() ?? '',
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Función para crear el footer del dialogo de agregar facturacion
  Widget _buildFooter(Map<String, dynamic>? inventario) {
    if (inventario == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    final int idInventario = inventario['idInventory'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('facturacion');
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
              onPressed: () {
                facturacionService.guardarFacturacion(context, idInventario);
              },
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
    final TextEditingController valorVentaController = TextEditingController();
    final TextEditingController descuentoPagoInicialController =
        TextEditingController();
    int? _selectedCliente;

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
                'Agregar Producto a la facturación',
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
                      const SizedBox(height: 16),
                      Consumer<ClientesProvider>(
                        builder: (context, clientesProvider, child) {
                          if (clientesProvider.isLoading) {
                            return CircularProgressIndicator();
                          }

                          if (clientesProvider.clientes.isEmpty) {
                            return Text("No hay clientes disponibles");
                          }

                          final clientes = clientesProvider.clientes;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Selecciona un cliente',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100]?.withOpacity(0.8),
                                prefixIcon: const Icon(Icons.category),
                              ),
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: _selectedCliente,
                                hint: Text('Clientes'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCliente = newValue;
                                  });
                                },
                                items: clientes.map((cliente) {
                                  return DropdownMenuItem<int>(
                                    value: cliente['idClient'],
                                    child: Text(cliente['name'] +
                                        ' ' +
                                        cliente['lastname']),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
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
                        controller: valorVentaController,
                        decoration: InputDecoration(
                          labelText: 'Valor de venta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descuentoPagoInicialController,
                        decoration: InputDecoration(
                          labelText: 'Descuento pago inicial',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.discount_sharp),
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
                        valorVentaController.text.isNotEmpty &&
                        descuentoPagoInicialController.text.isNotEmpty) {
                      _addProductWithDetails(
                        productName,
                        clasification,
                        int.parse(cantidadController.text),
                        double.parse(valorVentaController.text),
                        productId,
                        _selectedCliente!,
                        double.parse(descuentoPagoInicialController.text),
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
