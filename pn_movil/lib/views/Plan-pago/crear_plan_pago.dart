import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _fechaCorteController = TextEditingController();
  final TextEditingController _periocidadController = TextEditingController();
  final TextEditingController _cuotasController = TextEditingController();
  final TextEditingController _valorCuotaController = TextEditingController();
  DateTime? _selectedDate;
  bool _mostrarTablaFacturacion = false;

  int? _selectedCliente;

  @override
  void dispose() {
    _periocidadController.dispose();
    _cuotasController.dispose();
    _valorCuotaController.dispose();
    _fechaCorteController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 50),
              // Contenido principal
              if (_mostrarTablaFacturacion) _buildFacturacionTable(),
            ],
          ),
        ),
      ),
    );
  }

// Método para construir el título con la tabla
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
                              Future.microtask(() {
                                context
                                    .read<FacturacionProvider>()
                                    .obtenerFacturasPorCliente(
                                        context, _selectedCliente!);
                              });
                              // Mostrar la tabla
                              setState(() {
                                _mostrarTablaFacturacion = true;
                              });
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
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
            'Crear plan de pago de facturación #${factura['idFacturacion']}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField(
                  controller: _fechaCorteController,
                  labelText: 'Fecha de corte',
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _periocidadController,
                  labelText: 'Periocidad',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _cuotasController,
                  labelText: 'Número de cuotas',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _valorCuotaController,
                  labelText: 'Valor de cada cuota',
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
                final planPago = {
                  'fechaCorte': _fechaCorteController.text,
                  'perodicidad': _periocidadController.text,
                  'cuotas': _cuotasController.text,
                  'valorCuota': _valorCuotaController.text,
                };
                facturacionService.crearPlanPago(context, planPago,
                    _selectedCliente!, factura['idFacturacion']);
              },
              child: Text(
                'Crear',
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
        _fechaCorteController.text =
            "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
      });
    }
  }
}
