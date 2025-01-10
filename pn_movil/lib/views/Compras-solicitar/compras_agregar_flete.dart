import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/services/compras_service.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class ComprasAgregarFlete extends StatefulWidget {
  const ComprasAgregarFlete({super.key});

  @override
  State<ComprasAgregarFlete> createState() => _ComprasAgregarFleteState();
}

class _ComprasAgregarFleteState extends State<ComprasAgregarFlete> {
  late final ComprasService comprasService;
  final TextEditingController _fleteController = TextEditingController();

  List<bool> seleccionados = [];

  @override
  void initState() {
    super.initState();
    comprasService = ComprasService(ApiClient('https://apppn.duckdns.org'));
  }

  void _addProductoFleteSeleccionada(int productoId) {
    setState(() {
      comprasService.addProductoFlete(productoId);
    });
  }

  void _removeProductoFleteSeleccionada(int productoId) {
    setState(() {
      comprasService
          .removeProductoFlete(productoId); // Pasamos el ID directamente
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
            _buildHeader(),

            // Contenido principal
            Expanded(
              child: _buildMainContent(),
            ),

            // Botón de guardar
            _buildFooter(comprasService),
          ],
        ),
      ),
    );
  }

  //Widget para crear el header del dialogo de agregar producto
  Widget _buildHeader() {
    final compra =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final idCompa = compra?['idCompra'];

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: CardContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.blue.shade800,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Agregar Flete a la compra #$idCompa',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: TextFormField(
                  controller: _fleteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Ingresa el valor del flete',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    // Lógica para manejar el cambio en el valor
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget para crear el contenido principal
  Widget _buildMainContent() {
    final compra =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final productoCompras = compra?['productoCompras'] ?? [];

    if (seleccionados.isEmpty) {
      seleccionados = List<bool>.filled(productoCompras.length, false);
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              'Selecciona los productos que te llegaron: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productoCompras.length,
              itemBuilder: (context, index) {
                final productoCompra = productoCompras[index];
                final producto = productoCompra['producto'];
                final idProducto = producto['idProducto'];
                final imagen = producto['imagenes'].isNotEmpty
                    ? producto['imagenes'][0]
                    : 'assets/algo.jpg';

                final urlImagen = imagen is String ? imagen : imagen['urlPath'];

                final nombreProducto = producto['producto'];
                final cantidad = productoCompra['cantidad'];
                final costo = productoCompra['costo'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      seleccionados[index] = !seleccionados[index];
                      if (seleccionados[index]) {
                        _addProductoFleteSeleccionada(idProducto);
                      } else {
                        _removeProductoFleteSeleccionada(idProducto);
                      }
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: seleccionados[index]
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: urlImagen.startsWith('http')
                            ? Image.network(
                                urlImagen,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                urlImagen,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(
                        nombreProducto,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Cantidad: $cantidad',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                          Text(
                            'Costo: \$${costo.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: seleccionados[index],
                        onChanged: (bool? value) {
                          setState(() {
                            seleccionados[index] = value ?? false;

                            if (value == true) {
                              _addProductoFleteSeleccionada(idProducto);
                            } else {
                              _removeProductoFleteSeleccionada(idProducto);
                            }
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //Metodo para construir el botón de guardar
  Widget _buildFooter(
    ComprasService comprasService,
  ) {
    final compras =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final idCompra = compras?['idCompra'];

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
                        .pushReplacementNamed('compras-solicitar');
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
                    final flete = double.tryParse(_fleteController.text) ?? 0;

                    comprasService.guardarFlete(context, idCompra!, flete);
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
