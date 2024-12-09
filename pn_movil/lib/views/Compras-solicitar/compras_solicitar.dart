import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/providers/compra_provider.dart';
import 'package:pn_movil/widgets/Components-cards/cards_listar_products.dart';
import 'package:pn_movil/widgets/Components-generales/estado_compra.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class Compras extends StatefulWidget {
  const Compras({super.key});

  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CompraProvider>().loadCompras(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});

          return Consumer<CompraProvider>(
            builder: (context, compraProvider, child) {
              if (compraProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.blue.shade50],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Explora nuestras compras',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //Barra de busqueda de compras
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar compras...',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
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
                                    color: const Color.fromARGB(
                                        255, 175, 177, 178),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                        255, 175, 177, 178),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(112, 185, 244, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, 'compras-solicitar-crear');
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Listado de compras
                    ...compraProvider.compras.map((compra) {
                      //Listado de compras
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
                                    'Compra #${compra['idCompra']}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Realizada el ${DateFormat('dd/MM/yyyy').format(DateTime.parse(compra['fecha']))}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Proveedor: ${compra['proveedor']['proveedor']}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 4),
                                  estadoPagoWidget(compra['pago']),
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
                                          context,
                                          'compras-solicitar-detalle',
                                          arguments: compra,
                                        );
                                        break;
                                      case 'editar':
                                        Navigator.pushReplacementNamed(
                                          context,
                                          'compras-solicitar-editar',
                                          arguments: compra,
                                        );
                                        break;
                                      case 'pagar':
                                        Navigator.pushReplacementNamed(
                                          context,
                                          'crear-pago',
                                          arguments: compra,
                                        );
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    // Lista de opciones inicial
                                    List<PopupMenuEntry<String>> menuItems = [
                                      PopupMenuItem<String>(
                                        value: 'detalle',
                                        child: Row(
                                          children: const [
                                            Icon(Icons.visibility,
                                                color: Colors.blue),
                                            SizedBox(width: 10),
                                            Text('Ver detalles'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'editar',
                                        child: Row(
                                          children: const [
                                            Icon(Icons.edit,
                                                color: Colors.green),
                                            SizedBox(width: 10),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),
                                    ];

                                    if (compra['pago'] == null) {
                                      menuItems.add(
                                        PopupMenuItem<String>(
                                          value: 'pagar',
                                          child: Row(
                                            children: const [
                                              Icon(Icons.monetization_on,
                                                  color: Color.fromARGB(
                                                      255, 230, 185, 37)),
                                              SizedBox(width: 10),
                                              Text('Pagar'),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return menuItems;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
