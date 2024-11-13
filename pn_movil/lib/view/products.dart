import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/cardsListar.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Center(
          child: CardsListar(
        imageUrl: 'assets/algo.jpg',
        title: 'Adidas talla 32',
        subtitle: 'Son tennis de alta calidad con estilo unico',
        description: 'Este es un producto de alta calidad talla 32',
        onVisibilityTap: () {},
        onEditTap: () {},
      )),
    );
  }
}
