import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'dart:io';

import 'package:pn_movil/services/pago_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class CrearPago extends StatefulWidget {
  const CrearPago({super.key});

  @override
  State<CrearPago> createState() => _CrearPagoState();
}

class _CrearPagoState extends State<CrearPago> {
  late final PagoService pagoService;
  File? _imagenSeleccionada;

  @override
  void initState() {
    super.initState();
    pagoService = PagoService(ApiClient('https://apppn.duckdns.org'));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? compra =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
                    color: Colors.blue,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Crear Pago',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _formulario(context, compra),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formulario(BuildContext context, Map<String, dynamic>? compra) {
    TextEditingController _totalPagoController = TextEditingController();

    if (compra == null || compra['idCompra'] == null) {
      return const Center(
        child: Text(
          'No se pudo cargar la información de la compra.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final int idCompra = compra['idCompra'] as int;

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
                Text(
                  'Realizando pago de la compra #$idCompra',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    if (_imagenSeleccionada == null) {
                      final File? nuevaImagen =
                          await pagoService.seleccionarImagen();
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
                        height: 310,
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
                                    await pagoService.seleccionarImagen();
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
                  controller: _totalPagoController,
                  decoration: InputDecoration(
                    labelText: 'Total pago',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      double totalPago =
                          double.tryParse(_totalPagoController.text) ?? 0;
                      pagoService.guardarPago(
                          context, idCompra, _imagenSeleccionada, totalPago);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color.fromARGB(255, 90, 136, 204),
                    ),
                    child: const Text(
                      'Guardar Pago',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
