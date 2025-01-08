import 'dart:io';

import 'package:flutter/material.dart';
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
  //Campos para crear el pago de cliente
  late final FacturacionService facturacionService;
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _numeroRecibidoController =
      TextEditingController();
  final TextEditingController _tipoPagoController = TextEditingController();
  File? _imagenSeleccionada;

  // Variables para mostrar la tabla de facturación
  bool loadingAplicarPago = false;
  bool isLoading = false;

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
    final facturas = Provider.of<FacturacionProvider>(context).facturas;
    print(facturas);

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
              _buildFooter(facturas),
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
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
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
        ),
      ),
    );
  }

  //BOTON PARA GUARDAR EL PAGO
  Widget _buildFooter(List<Map<String, dynamic>> facturas) {
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
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      double totalPago =
                          double.tryParse(_valorController.text) ?? 0;

                      // Crear el DTO de pago solo si los valores no están vacíos
                      final aplicarPagoDTO = (_valorPagoAplicarController
                                  .text.isNotEmpty ||
                              _selectedCliente != null ||
                              _fechaCreacionController.text.isNotEmpty)
                          ? {
                              'valor':
                                  _valorPagoAplicarController.text.isNotEmpty
                                      ? _valorPagoAplicarController.text
                                      : null,
                              'idCliente': _selectedCliente ?? null,
                              'fechaPago':
                                  _fechaCreacionController.text.isNotEmpty
                                      ? _fechaCreacionController.text
                                      : null,
                            }
                          : null;

                      await pagoClienteService.guardarPagoCliente(
                        context,
                        _imagenSeleccionada,
                        totalPago,
                        _numeroRecibidoController.text,
                        _tipoPagoController.text,
                        aplicarPago: aplicarPagoDTO,
                      );

                      setState(() {
                        isLoading = false;
                      });
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color.fromARGB(255, 90, 136, 204),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
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
      lastDate: DateTime(2026),
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
