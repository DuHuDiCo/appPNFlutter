import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class CrearPago extends StatelessWidget {
  const CrearPago({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? compra =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _formulario(compra),
        ),
      ),
    );
  }

  //WIDGET DEL FORMULARIO DEL PAGO
  Widget _formulario(Map<String, dynamic>? compra) {
    if (compra == null || compra['idCompra'] == null) {
      print('Argumentos no válidos: $compra');
      return const Center(
        child: Text(
          'No se pudo cargar la información de la compra.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final int idCompra = compra['idCompra'] as int;
    print('ID de la compra: $idCompra');

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      color: Colors.blue,
                      size: 30,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Crear Pago',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Compra: #$idCompra',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Total pago',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color.fromARGB(255, 90, 136, 204),
                    ),
                    child: const Text(
                      'Guardar Pago',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
