import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';
import 'package:pn_movil/providers/inventario_provider.dart';
import 'package:pn_movil/services/inventario_service.dart';
import 'package:pn_movil/views/Inventario/detalle_inventario.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  late final InventarioService inventarioService;
  bool selectedIsNull = false;

  @override
  void initState() {
    super.initState();
    inventarioService =
        InventarioService(ApiClient('https://apppn.duckdns.org'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<InventarioProvider>()
          .loadInventarios(context, isNull: selectedIsNull == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTitle(),
            _buildSearchBar(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  //Metodo del titulo de inventario
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Explora tu inventario',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Metodo que construye el select de busqueda de filtros del inventario
  Widget _buildSearchBar() {
    List<bool> filterOptions = [false, true];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<bool>(
              value: selectedIsNull,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedIsNull = newValue;
                  });
                  _updateInventarios();
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.shade50,
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
                    color: Colors.blue.shade300,
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
              icon: Icon(
                Icons.arrow_drop_down,
                color: const Color.fromARGB(255, 175, 177, 178),
                size: 30.0,
              ),
              style: TextStyle(
                fontSize: 16.0,
                color: const Color.fromARGB(255, 175, 177, 178),
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              items: filterOptions.map<DropdownMenuItem<bool>>((bool value) {
                return DropdownMenuItem<bool>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(
                        value ? Icons.check_circle : Icons.cancel,
                        color: value ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        value ? 'Con facturación' : 'Sin facturación',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir el contenido principal del inventario
  Widget _buildMainContent() {
    return Consumer<InventarioProvider>(
      builder: (context, inventarioProvider, child) {
        if (inventarioProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (inventarioProvider.inventarios.isEmpty) {
          return const Center(
            child: Text(
              'No hay inventarios disponibles.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: inventarioProvider.inventarios.length,
          itemBuilder: (context, index) {
            final inventario = inventarioProvider.inventarios[index];
            final totalPorInventario =
                inventarioProvider.calcularTotalPorInventario(inventario);
            return ListItem(
              imageUrl: null,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inventario #${inventario['idInventory']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Realizado el ${DateFormat('dd/MM/yyyy').format(DateTime.parse(inventario['dateInventory']))}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cantidad general: ${inventario['quantity']}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${inventarioService.formatCurrencyToCOP(totalPorInventario)}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, 'detalle-inventario',
                          arguments: inventario);
                    },
                    icon: const Icon(Icons.visibility),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(112, 185, 244, 1),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Metodo para actualizar los inventarios
  void _updateInventarios() {
    context
        .read<InventarioProvider>()
        .loadInventarios(context, isNull: selectedIsNull == true);
  }
}
