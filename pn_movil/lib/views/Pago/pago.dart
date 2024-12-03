import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/providers/pago_provider.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class Pago extends StatefulWidget {
  const Pago({super.key});

  @override
  _PagoState createState() => _PagoState();
}

class _PagoState extends State<Pago> {
  @override
  void initState() {
    super.initState();
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
            // Título principal
            _buildTitle(),

            // Barra de búsqueda
            _buildSearchBar(),

            // Contenido principal
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
      child: Text(
        'Explora nuestros pagos',
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
                hintText: 'Buscar pagos...',
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

  Widget _buildMainContent() {
    Future.microtask(() => context.read<PagoProvider>().loadPagos(context));

    return Consumer<PagoProvider>(
      builder: (context, pagoProvider, child) {
        if (pagoProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (pagoProvider.pagos.isEmpty) {
          return const Center(
            child: Text(
              'No hay pagos disponibles.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: pagoProvider.pagos.length,
            itemBuilder: (context, index) {
              final pago = pagoProvider.pagos[index];
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
                            'Pago #${pago['idPago']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pago['archivos']['fechaCreacion']))}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: \$${pago['totalPago']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color.fromRGBO(112, 185, 244, 1),
                            size: 30,
                          ),
                          onSelected: (String value) {
                            switch (value) {
                              case 'detalle':
                                Navigator.pushReplacementNamed(
                                    context, 'pagos-detalle',
                                    arguments: pago);
                                break;
                              case 'eliminar':
                                _confirmarEliminacion(pago['numeroPago']);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'detalle',
                              child: Row(
                                children: const [
                                  Icon(Icons.visibility, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Ver detalles'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'eliminar',
                              child: Row(
                                children: const [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Eliminar'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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

// Método para confirmar eliminación
  void _confirmarEliminacion(int numeroPago) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el pago #$numeroPago?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para eliminar el pago
                Navigator.of(context).pop();
                // Muestra una notificación de éxito o actualiza la lista
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
