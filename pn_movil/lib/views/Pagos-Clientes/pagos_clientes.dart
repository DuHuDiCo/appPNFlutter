import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/clientes_provider.dart';
import 'package:pn_movil/providers/pago_cliente_provider.dart';
import 'package:pn_movil/services/pago_cliente_service.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class PagosClientes extends StatefulWidget {
  const PagosClientes({super.key});

  @override
  _PagosClientesState createState() => _PagosClientesState();
}

class _PagosClientesState extends State<PagosClientes> {
  late final PagoClienteService pagoClienteService;
  int? _selectedCliente;

  @override
  void initState() {
    super.initState();
    pagoClienteService =
        PagoClienteService(ApiClient('https://apppn.duckdns.org'));

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
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
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
              'Explora nuestros pagos de clientes aplicados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Botón de crear
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(112, 185, 244, 1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'crear-pagos-clientes');
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
              iconSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  //Metodo para construir la barra de busqueda
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

            // Verifica si no hay clientes
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
                          // Aseguramos que el cliente seleccionado se actualice
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
                              .read<PagoClienteProvider>()
                              .obtenerPagoPorId(context, _selectedCliente!);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor selecciona un cliente.'),
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
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Restablece el cliente seleccionado y el proveedor
                      context.read<PagoClienteProvider>().resetPagosFiltrados();
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
            );
          },
        ),
      ),
    );
  }

//Metodo para construir el contenido principal
  Widget _buildMainContent() {
    Future.microtask(
        () => context.read<PagoClienteProvider>().loadPagosClientes(context));
    return Consumer<PagoClienteProvider>(
      builder: (context, pagoClienteProvider, child) {
        if (pagoClienteProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (pagoClienteProvider.pagosClientes.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron pagos para este cliente.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: pagoClienteProvider.pagosClientes.length,
            itemBuilder: (context, index) {
              final pagoCliente = pagoClienteProvider.pagosClientes[index];

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
                            'Pago #${pagoCliente['idPagoCliente']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Realizada el ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pagoCliente['fechaPago']))}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total pago: ${pagoClienteService.formatCurrencyToCOP(pagoCliente["valor"])}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
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
                              case 'comprobante':
                                _mostrarComprobanteDialog(context,
                                    pagoCliente['archivos']['urlPath']);
                                break;
                              case 'Eliminar':
                                _confirmarEliminacion(
                                    context,
                                    pagoCliente['idPagoCliente'],
                                    pagoClienteService);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'comprobante',
                              child: Row(
                                children: const [
                                  Icon(Icons.visibility, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Ver comprobante'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Eliminar',
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
                    )
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
  void _confirmarEliminacion(BuildContext context, int idPagoCliente,
      PagoClienteService pagoClienteService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar pago del cliente'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el pago #$idPagoCliente del cliente?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await pagoClienteService.eliminarpagoCliente(
                      context, idPagoCliente);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pago del cliente eliminado exitosamente'),
                    ),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const PagosClientes()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

//Metodo para mostrar el dialogo de comprobante
  void _mostrarComprobanteDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
