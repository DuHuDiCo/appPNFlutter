import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';
import 'package:pn_movil/services/abono_service.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class AbonoNormal extends StatefulWidget {
  const AbonoNormal({super.key});

  @override
  State<AbonoNormal> createState() => _AbonoNormalState();
}

class _AbonoNormalState extends State<AbonoNormal> {
  late final AbonoService abonoService;
  List<Map<String, dynamic>> cuotasSeleccionadas = [];
  final TextEditingController _precioFinalController = TextEditingController();
  int? _selectedCliente;

  @override
  void initState() {
    super.initState();

    abonoService = AbonoService(ApiClient('https://apppn.duckdns.org'));
    abonoService.clearSelectedCuotas();
    abonoService.addListener(_actualizarPrecioFinal);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ClientesProvider>(context, listen: false)
            .loadClientes(context);
      }
    });
  }

  @override
  void dispose() {
    abonoService.removeListener(_actualizarPrecioFinal);
    _precioFinalController.dispose();
    super.dispose();
  }

  // Método para actualizar el campo de precio final
  void _actualizarPrecioFinal() {
    final total = abonoService.calcularTotalCuotas();
    _precioFinalController.text = total.toStringAsFixed(0);
  }

  void _addCuotaSeleccionada(int cuotaId, int facturacionId, double saldo) {
    setState(() {
      abonoService.addCuotas({
        'idCuota': cuotaId.toString(),
        'valor': '0',
        'idFacturacion': facturacionId.toString(),
        'saldo': saldo.toString(),
      });
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

            // Contenido principal
            Expanded(
              child: _buildMainContent(),
            ),

            // Botón de guardar
            _buildFooter(abonoService),
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
              'Crear aplicación de abono',
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
                TextField(
                  controller: _precioFinalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Precio a pagar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    // Convertir el valor ingresado en el campo a un número decimal
                    final nuevoValor = double.tryParse(value) ?? 0.0;

                    // Llamar a la función para distribuir el pago con el nuevo valor
                    abonoService.distribuirPago(nuevoValor);

                    // Actualizar el controlador sin interferir con la entrada del usuario
                    setState(() {
                      _precioFinalController.text =
                          nuevoValor > 0 ? nuevoValor.toStringAsFixed(0) : '';
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

// Método principal para construir el contenido
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

        final facturas = (facturacionesClientes['cuentaDTOs'] ?? [])
            .where((factura) =>
                factura['facturacion'] != null &&
                (factura['facturacion'] as List).any((facturacion) =>
                    (facturacion['cuotas'] as List)
                        .any((cuota) => cuota['saldo'] > 0)))
            .toList();

        if (facturas.isEmpty) {
          return const Center(
            child: Text(
              'No tiene facturas pendientes.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: facturas.length,
            itemBuilder: (context, index) {
              final factura = facturas[index];
              return _buildFacturaCard(factura);
            },
          ),
        );
      },
    );
  }

// Widget para una factura (nivel principal)
  Widget _buildFacturaCard(Map<String, dynamic> factura) {
    final valor = factura['valor'];
    final fecha = factura['fecha'];
    final facturaciones = factura['facturacion'] ?? [];
    final isFacturaExpanded = factura['isExpanded'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      factura['isExpanded'] = !isFacturaExpanded;
                    });
                  },
                  icon: Icon(
                    isFacturaExpanded
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
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (isFacturaExpanded)
              Column(
                children: facturaciones.map<Widget>((facturacion) {
                  return _buildFacturacionCard(facturacion);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

// Widget para las facturaciones
  Widget _buildFacturacionCard(Map<String, dynamic> facturacion) {
    final idFacturacion = facturacion['idFacturacion'];
    final fechaFacturacion = facturacion['fecha'];
    final cuotas = facturacion['cuotas'] ?? [];
    final isFacturacionExpanded = facturacion['isExpanded'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Facturación #$idFacturacion',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      facturacion['isExpanded'] = !isFacturacionExpanded;
                    });
                  },
                  icon: Icon(
                    isFacturacionExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
              ],
            ),
            Text(
              'Fecha factura: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(fechaFacturacion))}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            if (isFacturacionExpanded)
              Column(
                children: cuotas.map<Widget>((cuota) {
                  return _buildCuotaTile(cuota, facturacion);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

// Widget para las cuotas de una facturación
  Widget _buildCuotaTile(
      Map<String, dynamic> cuota, Map<String, dynamic> facturacion) {
    final idFacturacion = facturacion['idFacturacion'];

    final idCuota = cuota['idCuota'];
    final saldo = cuota['saldo'];
    final fechaPago = cuota['fechaPago'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Cuota $idCuota - Saldo: ${abonoService.formatCurrencyToCOP(saldo)} - Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(fechaPago))}',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        value: cuota['isSelected'] ?? false,
        onChanged: (bool? value) {
          setState(() {
            cuota['isSelected'] = value;

            if (value == true) {
              _addCuotaSeleccionada(
                idCuota,
                idFacturacion,
                saldo,
              );
            } else {
              abonoService.removeCuota(idCuota);
            }
          });
        },
        activeColor: Colors.blueAccent,
        checkColor: Colors.white,
      ),
    );
  }

  //Metodo para construir el botón de guardar
  Widget _buildFooter(
    AbonoService abonoService,
  ) {
    final pagoCliente =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final idPagoCliente = pagoCliente?['idPagoCliente'];

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
                    Navigator.of(context)
                        .pushReplacementNamed('pagos-clientes-sin-aplicar');
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
                    abonoService.guardarAbono(
                        context, _selectedCliente!, idPagoCliente);
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
        ],
      ),
    );
  }
}
