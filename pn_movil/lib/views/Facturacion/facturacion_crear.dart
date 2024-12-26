import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
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
  bool isRegistrarButtonEnabled = false;
  final TextEditingController _periocidadController = TextEditingController();
  final TextEditingController _cuotasController = TextEditingController();
  final TextEditingController _valorCuotaController = TextEditingController();
  final TextEditingController _fechaCorteController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Inicialización del servicio
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));

    // Asegúrate de que el widget esté montado antes de acceder al Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ClientesProvider>(context, listen: false)
            .loadClientes(context);
      }
    });
  }

  @override
  void dispose() {
    _periocidadController.dispose();
    _cuotasController.dispose();
    _valorCuotaController.dispose();
    _fechaCorteController.dispose();
    super.dispose();
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

    final Map<String, dynamic>? factura =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    print(' inventario Desde Vista: $inventario');

    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Título principal
              _buildHeader(),

              // Contenido principal
              _buildMainContent(inventario, factura),

              // Botón para guardar la facturación
              _buildFooter(facturacionService, inventario),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: Colors.blue.shade800,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Registrar factura',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Primer TextFormField
                  Expanded(
                    child: TextFormField(
                      controller: _fechaCorteController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Fecha de corte',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            _selectedDate = selectedDate;
                            _fechaCorteController.text =
                                "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Segundo TextFormField
                  Expanded(
                    child: TextFormField(
                      controller: _periocidadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Periocidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cuotasController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de cuotas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _valorCuotaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor de cada cuota',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  //Meotodo para construir el contenido principal
  Widget _buildMainContent(
      Map<String, dynamic>? inventario, Map<String, dynamic>? factura) {
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
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    height: 300,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                        return ProductFacturacion(
                          imageUrl: (producto['imagenes'] is List &&
                                  producto['imagenes'].isNotEmpty)
                              ? producto['imagenes'][0]['urlPath']
                              : 'assets/algo.jpg',
                          productName:
                              producto['producto'] ?? 'Producto sin nombre',
                          clasification: producto['clasificacionProducto']
                                  ?['clasificacionProducto'] ??
                              'Sin clasificar',
                          costo: facturacionService
                              .formatCurrencyToCOP(productData['costo']),
                          cantidad: productData['cantidad'],
                          onAddProduct:
                              (productName, clasification, productId) {
                            _showAddProductDialog(
                                context,
                                productName,
                                clasification,
                                productData['cantidad'],
                                productId,
                                factura);
                          },
                          onRemoveProduct: (name, clasification) {
                            setState(() {
                              facturacionService.removeProduct(
                                  productData['idProductoCompra']);
                            });
                          },
                          isSelected: isSelected,
                          productId:
                              productData['idProductoCompra']?.toString() ?? '',
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Dialogo para agregar producto
  Future<void> _showAddProductDialog(
      BuildContext context,
      String productName,
      String clasification,
      int cantidad,
      String productId,
      Map<String, dynamic>? factura) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController valorVentaController = TextEditingController();
    final TextEditingController descuentoPagoInicialController =
        TextEditingController();

    int? _selectedCliente;
    String? clienteError;
    String? errorCantidad;
    String? errorValorVenta;
    String? errorDescuentoPagoInicial;

    void validateField() {
      setState(() {
        if (_selectedCliente == null) {
          clienteError = 'Este campo no puede estar vacío';
        } else {
          clienteError = null;
        }

        if (cantidadController.text.isEmpty) {
          errorCantidad = 'Este campo no puede estar vacío';
        } else {
          errorCantidad = null;
        }

        if (valorVentaController.text.isEmpty) {
          errorValorVenta = 'Este campo no puede estar vacío';
        } else {
          errorValorVenta = null;
        }

        if (descuentoPagoInicialController.text.isEmpty) {
          errorDescuentoPagoInicial = 'Este campo no puede estar vacío';
        } else {
          errorDescuentoPagoInicial = null;
        }
      });
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
                                errorText: clienteError,
                              ),
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: _selectedCliente,
                                hint: Text('Clientes'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCliente = newValue;
                                    clienteError = null;
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
                          errorText: errorCantidad,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              errorCantidad = null;
                            });
                          }
                        },
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
                          errorText: errorValorVenta,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              errorValorVenta = null;
                            });
                          }
                        },
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
                          errorText: errorDescuentoPagoInicial,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              errorDescuentoPagoInicial = null;
                            });
                          }
                        },
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
                    setState(() {
                      validateField();
                    });
                    if (_selectedCliente != null &&
                        cantidadController.text.isNotEmpty &&
                        valorVentaController.text.isNotEmpty &&
                        descuentoPagoInicialController.text.isNotEmpty) {
                      int cantidadIngresada =
                          int.parse(cantidadController.text);
                      if (cantidadIngresada > cantidad) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'La cantidad ingresada supera el límite permitido.'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
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

  //Metodo para construir el footer del dialogo de agregar producto
  Widget _buildFooter(
      FacturacionService facturacionService, Map<String, dynamic>? inventario) {
    if (inventario == null) {
      return const Center(
        child: Text('No se pudo cargar la información de la compra.'),
      );
    }

    final int idInventario = inventario['idInventory'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('inventario');
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
                  onPressed: facturacionService.hasSelectedProducts
                      ? () {
                          if (_selectedDate != null) {
                            // Validar y convertir los valores de los controladores
                            final String periocidadText =
                                _periocidadController.text.trim();
                            final String cuotasText =
                                _cuotasController.text.trim();
                            final String valorCuotaText =
                                _valorCuotaController.text.trim();

                            final int? periocidad =
                                int.tryParse(periocidadText);
                            final int? cuotas = int.tryParse(cuotasText);
                            final double? valorCuota =
                                double.tryParse(valorCuotaText);

                            if (periocidad != null &&
                                cuotas != null &&
                                valorCuota != null) {
                              facturacionService.guardarFacturacion(
                                context,
                                idInventario,
                                periocidad,
                                cuotas,
                                valorCuota,
                                _selectedDate!.toIso8601String(),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor, ingresa valores válidos.'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Por favor, selecciona una fecha.'),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: facturacionService.hasSelectedProducts &&
                            _periocidadController.text.isNotEmpty &&
                            _cuotasController.text.isNotEmpty &&
                            _valorCuotaController.text.isNotEmpty &&
                            _selectedDate != null &&
                            int.tryParse(_periocidadController.text.trim()) !=
                                null &&
                            int.tryParse(_cuotasController.text.trim()) !=
                                null &&
                            double.tryParse(
                                    _valorCuotaController.text.trim()) !=
                                null
                        ? Colors.blue
                        : Colors.grey,
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
        ],
      ),
    );
  }
}
