import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/abono_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class ResumenCuenta extends StatefulWidget {
  const ResumenCuenta({super.key});

  @override
  State<ResumenCuenta> createState() => _ResumenCuentaState();
}

class _ResumenCuentaState extends State<ResumenCuenta> {
  late final AbonoService abonoService;
  int? _selectedCliente;

  @override
  void initState() {
    super.initState();

    abonoService = AbonoService(ApiClient('https://apppn.duckdns.org'));
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
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título principal
            _buildTitle(),

            // Barra de búsqueda
            _buildSearchBar(),

            //Cintenido principal
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  // Método para construir el título
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Buscar resumen de cuenta',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

// Método para construir la barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Consumer<ClientesProvider>(
          builder: (context, clientesProvider, child) {
            // Verifica si se está cargando
            if (clientesProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (clientesProvider.clientes.isEmpty) {
              return const Text("No hay clientes disponibles");
            }

            final clientes = clientesProvider.clientes;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            context
                                .read<FacturacionProvider>()
                                .resumenDePagosPorClienteId(
                                    context, _selectedCliente!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Por favor selecciona un cliente.'),
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
                    const SizedBox(width: 10),
                    // Botón de reset
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<FacturacionProvider>().resetFiltrados();
                          setState(() {
                            _selectedCliente = null;
                          });
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  // Método para construir el contenido principal
  Widget _buildMainContent() {
    return Consumer<FacturacionProvider>(
      builder: (context, facturacionProvider, child) {
        if (_selectedCliente == null) {
          return const Center(
            child: Text(
              'Por favor selecciona un cliente y realiza una búsqueda.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        if (facturacionProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final facturacionesClientes =
            facturacionProvider.filteredFacturacionesClientes;

        if (facturacionesClientes.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron facturaciones para este cliente.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final facturas =
            (facturacionesClientes['cuentaDTOs'] ?? []).where((factura) {
          if (factura['facturacion'] is List &&
              factura['facturacion'].isNotEmpty) {
            final cuotas = factura['facturacion'][0]['cuotas'] ?? [];
            if (cuotas is List) {
              return cuotas
                  .any((cuota) => cuota['saldo'] != null && cuota['saldo'] > 0);
            }
          }
          return false;
        }).toList();

        if (facturas.isEmpty) {
          return const Center(
            child: Text(
              'No tiene facturas con cuotas pendientes por pagar.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: facturas.length,
            itemBuilder: (context, index) {
              final factura = facturas[index];
              final valor = factura['valor'];
              final fecha = factura['fecha'];
              final cuotas = factura['facturacion'][0]['cuotas'] ?? [];

              bool isExpanded = factura['isExpanded'] ?? false;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                shadowColor: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valor pendiente: ${abonoService.formatCurrencyToCOP(valor)}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                factura['isExpanded'] = !isExpanded;
                              });
                            },
                            icon: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha a pagar: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(fecha))}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Facturación #${factura['facturacion'][0]['idFacturacion']}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Fecha factura: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(factura['facturacion'][0]['fecha']))}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      if (isExpanded) const SizedBox(height: 12),
                      if (isExpanded)
                        ...cuotas
                            .where((cuota) =>
                                cuota['saldo'] != null &&
                                cuota['saldo'] is num &&
                                cuota['saldo'] > 0)
                            .map((cuota) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'Cuota ${cuota['idCuota']} - Saldo: ${abonoService.formatCurrencyToCOP(cuota['saldo'])} - Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cuota['fechaPago']))}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
