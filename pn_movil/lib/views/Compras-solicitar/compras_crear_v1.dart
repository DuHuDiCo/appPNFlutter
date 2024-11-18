import 'package:flutter/material.dart';
import 'package:pn_movil/views/Compras-solicitar/form_compras_solicitar.dart';
import 'package:pn_movil/widgets/botton_CP.dart';
import 'package:pn_movil/widgets/card_container.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class ComprasSolicitarCrearV1 extends StatelessWidget {
  const ComprasSolicitarCrearV1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: [
            const SizedBox(height: 50),
            Center(
              child: SingleChildScrollView(
                child: CardContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: Colors.blue.shade800,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Registrar Compra',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomToggleButton(),
                      const SizedBox(height: 40),
                      FormComprasSolicitar(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
                      ),
                      child: Text(
                        'Total: 0',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 244, 245, 246),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción del botón Guardar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 244, 245, 246),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
