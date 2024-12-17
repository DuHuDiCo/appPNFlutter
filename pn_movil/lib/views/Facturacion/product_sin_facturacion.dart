import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/products_sin_facturacion_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class ProductSinFacturacion extends StatefulWidget {
  const ProductSinFacturacion({super.key});

  @override
  State<ProductSinFacturacion> createState() => _ProductSinFacturacionState();
}

class _ProductSinFacturacionState extends State<ProductSinFacturacion> {
  late final FacturacionService facturacionService;
  List<Map<String, dynamic>> productoSeleccionado = [];

  @override
  void initState() {
    super.initState();
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));

    Future.microtask(() => context
        .read<ProductsSinFacturacionProvider>()
        .loadProductosSinFacturacion(context));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientesProvider>(context, listen: false)
          .loadClientes(context);
    });
  }

  void _addProductWithDetails(String name, String clasification, int cantidad,
      double valorVenta, String productId, int clientId, double descuento) {
    if (productoSeleccionado.any((product) =>
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

    print(productoSeleccionado);
  }

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
                      'Cantidad: ${productoSinFacturacion['cantidadInventario']}',
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
                      _showAddProductDialog(
                          productoSinFacturacion['productoCompra']['producto']
                              ['producto'],
                          productoSinFacturacion['productoCompra']['producto']
                                  ['clasificacionProducto']
                              ['clasificacionProducto'],
                          productoSinFacturacion['productoCompra']
                                      ['idProductoCompra']
                                  ?.toString() ??
                              '',
                          productoSinFacturacion);
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

  //Dialogo para agregar producto
  Future<void> _showAddProductDialog(String productName, String clasification,
      String productId, Map<String, dynamic>? productoSinFacturacion) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController valorVentaController = TextEditingController();
    final TextEditingController descuentoPagoInicialController =
        TextEditingController();
    int? _selectedCliente;

    int cantidadProducto =
        productoSinFacturacion?['productoCompra']?['cantidad'] ?? 0;

    print(cantidadProducto);

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
                'Facturar Producto',
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
                      final idInventario =
                          productoSinFacturacion?['inventory']['idInventory'];
                      facturacionService.guardarFacturacion(
                          context, idInventario);

                      // Navigator.of(context).pop(true);
                    }
                  },
                  child: const Text(
                    'Facturar',
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
