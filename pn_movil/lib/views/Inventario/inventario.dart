import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';
import 'package:pn_movil/providers/inventario_provider.dart';
import 'package:pn_movil/services/inventario_service.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  late final InventarioService inventarioService;
  @override
  void initState() {
    super.initState();
    inventarioService =
        InventarioService(ApiClient('https://apppn.duckdns.org'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventarioProvider>(context, listen: false)
          .loadInventarios(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTitle(),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  // Método para construir el título
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

  // Método para construir la barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar inventario...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Metodo para construir el contenido principal
  Widget _buildMainContent() {
    Future.microtask(
        () => context.read<InventarioProvider>().loadInventarios(context));

    return Consumer<InventarioProvider>(
      builder: (context, inventarioProvider, child) {
        if (inventarioProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (inventarioProvider.inventarios.isEmpty) {
          return const Center(
            child: Text(
              'No hay inventarios disponibles.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: inventarioProvider.inventarios.length,
            itemBuilder: (context, index) {
              final inventario = inventarioProvider.inventarios[index];
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
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(inventario['dateInventory']))}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total inventario: ${inventarioService.formatCurrencyToCOP(inventario["totalInventoryValue"])}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cantidad: ${inventario["quantity"]}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
