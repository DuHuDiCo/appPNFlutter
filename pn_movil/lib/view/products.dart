import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/cards_listar_products.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class Products extends StatelessWidget {
  const Products({super.key});

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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Explora nuestros productos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar productos...',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
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
                        Navigator.pushReplacementNamed(context, 'crearProduct');
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListItem(
              imageUrl: 'assets/algo.jpg',
              title: 'Adidas talla 32',
              description:
                  'Un texto es una composición de signos codificados en un sistema.',
              onVisibilityTap: () {},
              onEditTap: () {},
            ),
            const SizedBox(height: 12),
            ListItem(
              imageUrl:
                  'https://cdn.royalcanin-weshare-online.io/zlY7qG0BBKJuub5q1Vk6/v1/59-es-l-golden-running-thinking-getting-dog-beneficios',
              title: 'Nike talla 40',
              description:
                  'Descripción adicional de otro producto que puedes agregar en la lista.',
              onVisibilityTap: () {},
              onEditTap: () {},
            ),
            const SizedBox(height: 12),
            ListItem(
              imageUrl: 'assets/algo.jpg',
              title: 'Puma talla 38',
              description:
                  'Un tercer registro para mostrar la capacidad de listar varios ítems.',
              onVisibilityTap: () {},
              onEditTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
