import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/services/pago_cliente_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class CrearPagosClientes extends StatefulWidget {
  const CrearPagosClientes({super.key});

  @override
  State<CrearPagosClientes> createState() => _CrearPagosClientesState();
}

class _CrearPagosClientesState extends State<CrearPagosClientes> {
  late final PagoClienteService pagoClienteService;
  late Map<String, dynamic> factura;
  //Campos para crear el pago de cliente
  late final FacturacionService facturacionService;
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _numeroRecibidoController =
      TextEditingController();
  final TextEditingController _tipoPagoController = TextEditingController();
  File? _imagenSeleccionada;

  // Variables para mostrar la tabla de facturación
  bool _mostrarTablaFacturacion = false;
  bool loadingAplicarPago = false;

  // Variables para crear el aplicar pago
  final TextEditingController _fechaCreacionController =
      TextEditingController();
  final TextEditingController _valorPagoAplicarController =
      TextEditingController();
  DateTime? _selectedDate;
  int? _selectedCliente;

  @override
  void dispose() {
    _numeroRecibidoController.dispose();
    _tipoPagoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pagoClienteService =
        PagoClienteService(ApiClient('https://apppn.duckdns.org'));

    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ClientesProvider>(context, listen: false)
            .loadClientes(context);
      }

      Provider.of<FacturacionProvider>(context, listen: false)
          .loadFacturas(context);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: Colors.blue.shade800,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loadingAplicarPago
                        ? 'Aplicar Pago'
                        : 'Crear Pago de Cliente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(width: 40),
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
                          loadingAplicarPago =
                              loadingAplicarPago ? false : true;
                        });
                      },
                      icon: Icon(
                        loadingAplicarPago ? Icons.arrow_back : Icons.add,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              if (loadingAplicarPago == false)
                Expanded(
                  child: _formularioPagoCliente(context),
                ),
              if (loadingAplicarPago)
                Expanded(
                  child: _formularioAplicarPago(context),
                ),
              if (_mostrarTablaFacturacion && loadingAplicarPago)
                Expanded(
                  child: _buildFacturacionTable(),
                ),
              _buildFooter(factura),
            ],
          ),
        ),
      ),
    );
  }

  //Función para construir el formulario de creación de pago
  Widget _formularioPagoCliente(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // Añadir ScrollView aquí
        child: Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_imagenSeleccionada == null) {
                      final File? nuevaImagen =
                          await pagoClienteService.seleccionarImagen();
                      if (nuevaImagen != null) {
                        setState(() {
                          _imagenSeleccionada = nuevaImagen;
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _imagenSeleccionada!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imagenSeleccionada == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        size: 40, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Seleccionar comprobante de pago',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Image.file(
                                _imagenSeleccionada!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      if (_imagenSeleccionada != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 30,
                              ),
                              onPressed: () async {
                                final File? nuevaImagen =
                                    await pagoClienteService
                                        .seleccionarImagen();
                                if (nuevaImagen != null) {
                                  setState(() {
                                    _imagenSeleccionada = nuevaImagen;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _valorController,
                  decoration: InputDecoration(
                    labelText: 'Total pago',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _numeroRecibidoController,
                  decoration: InputDecoration(
                    labelText: 'Número del recibo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _tipoPagoController,
                  decoration: InputDecoration(
                    labelText: 'Tipo de pago',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para construir el formulario
  Widget _formularioAplicarPago(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<ClientesProvider>(
                  builder: (context, clientesProvider, child) {
                    if (clientesProvider.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    if (clientesProvider.clientes.isEmpty) {
                      return const Text("No hay clientes disponibles");
                    }

                    final clientes = clientesProvider.clientes;

                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[100]?.withOpacity(0.8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: _selectedCliente,
                                hint: const Text('Selecciona un cliente'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCliente = newValue;
                                  });
                                },
                                items: clientes.map((cliente) {
                                  return DropdownMenuItem<int>(
                                    value: cliente['idClient'],
                                    child: Text(
                                      '${cliente['name']} ${cliente['lastname']}',
                                    ),
                                  );
                                }).toList(),
                                dropdownColor: Colors.white,
                                menuMaxHeight: 200,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Botón de búsqueda
                        Container(
                          width: 50,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(112, 185, 244, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_selectedCliente != null) {
                                Future.microtask(() {
                                  context
                                      .read<FacturacionProvider>()
                                      .obtenerFacturasPorClienteId(
                                          context, _selectedCliente!);
                                });

                                setState(() {
                                  _mostrarTablaFacturacion = true;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor selecciona un cliente.'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para construir la tabla de facturación
  Widget _buildFacturacionTable() {
    return Consumer<FacturacionProvider>(
      builder: (context, facturacionProvider, _) {
        if (facturacionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (facturacionProvider.facturas.isEmpty) {
          return const Center(
            child: Text('No se encontraron facturaciones.'),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
            columnSpacing: 20,
            dataTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            columns: [
              DataColumn(
                label: Text(
                  'Factura',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Fecha Creacion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
            rows: facturacionProvider.facturas.map((factura) {
              final id = factura['idFacturacion'] ?? '-';
              final fecha = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(factura['fecha']));
              final total = facturacionService
                  .formatCurrencyToCOP(factura['totalFacturacion']);

              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.blue.shade50;
                  }
                  return (factura['idFacturacion']!.hashCode % 2 == 0)
                      ? Colors.grey.shade50
                      : Colors.white;
                }),
                cells: [
                  DataCell(
                    Center(
                      child: Text('$id'),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(fecha),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: Text(total),
                    ),
                  ),
                ],
                onSelectChanged: (selected) {
                  if (selected == true) {
                    _showModal(context, factura);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Método para mostrar el diálogo para crear un plan de pago
  void _showModal(BuildContext context, Map<String, dynamic> factura) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Crear aplicacion de pago de facturación #${factura['idFacturacion']}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField(
                  controller: _fechaCreacionController,
                  labelText: 'Fecha de creación',
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _valorPagoAplicarController,
                  labelText: 'Valor de pago',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                final aplicarPagoDTO = {
                  'valorPago': _valorPagoAplicarController.text,
                  'idCliente': _selectedCliente,
                  'idFacturacion': factura['idFacturacion'],
                  'fechaCreacion': _fechaCreacionController.text,
                };
                facturacionService.crearPlanPago(context, aplicarPagoDTO,
                    _selectedCliente!, factura['idFacturacion']);
              },
              child: Text(
                'Crear aplicacion',
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
  }

  //BOTON PARA GUARDAR EL PAGO
  Widget _buildFooter(Map<String, dynamic> factura) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('pagos-clientes');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: const Text(
                'Regresar',
                style: TextStyle(
                  fontSize: 16,
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
                double totalPago = double.tryParse(_valorController.text) ?? 0;

                final aplicarPagoDTO = {
                  'valorPago': _valorPagoAplicarController.text,
                  'idCliente': _selectedCliente,
                  'idFacturacion': factura['idFacturacion'],
                  'fechaCreacion': _fechaCreacionController.text,
                };
                pagoClienteService.guardarPagoCliente(
                  context,
                  _imagenSeleccionada,
                  totalPago,
                  _numeroRecibidoController.text,
                  _tipoPagoController.text,
                  aplicarPago: aplicarPagoDTO ?? null,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 90, 136, 204),
              ),
              child: const Text(
                'Guardar Pago',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Metodo para construir el estilo del input
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    IconData? suffixIcon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.blue.shade600)
            : null,
      ),
      onTap: onTap,
    );
  }

//Metodo para mostrar el selector de fecha
  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _fechaCreacionController.text =
            "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
      });
    }
  }
}
