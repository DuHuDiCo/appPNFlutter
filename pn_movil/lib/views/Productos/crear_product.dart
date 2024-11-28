import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/views/Productos/form_product.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class CrearProduct extends StatelessWidget {
  const CrearProduct({super.key});

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
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.business_sharp,
                    color: Colors.blue.shade800,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Crear Producto',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SingleChildScrollView(
                child: CardContainer(
                  child: FormularioProducto(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
