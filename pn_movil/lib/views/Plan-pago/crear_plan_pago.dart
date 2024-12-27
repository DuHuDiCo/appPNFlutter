import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/facturacion_service.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class CrearPlanPago extends StatefulWidget {
  const CrearPlanPago({super.key});

  @override
  _CrearPlanPagoState createState() => _CrearPlanPagoState();
}

class _CrearPlanPagoState extends State<CrearPlanPago> {
  late final FacturacionService facturacionService;
  int? _selectedCliente;
//
  @override
  void initState() {
    super.initState();
    // Inicialización del servicio
    facturacionService =
        FacturacionService(ApiClient('https://apppn.duckdns.org'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ClientesProvider>(context, listen: false)
            .loadClientes(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir el título
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
                    'Crear Plan de pago',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Consumer<ClientesProvider>(
                builder: (context, clientesProvider, child) {
                  if (clientesProvider.isLoading) {
                    return CircularProgressIndicator();
                  }

                  if (clientesProvider.clientes.isEmpty) {
                    return Text("No hay clientes disponibles");
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(112, 185, 244, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            print("Cliente seleccionado: $_selectedCliente");
                            Future.microtask(
                              () => context
                                  .read<FacturacionProvider>()
                                  .obtenerFacturasPorCliente(
                                      context, _selectedCliente!),
                            );
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
            ],
          ),
        ),
      ),
    );
  }
}
