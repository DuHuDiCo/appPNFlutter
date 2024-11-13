import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class Crearproduct extends StatelessWidget {
  const Crearproduct({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      drawer: CustomDrawer(),
      body: CrearProductBody(),
    );
  }
}

class CrearProductBody extends StatelessWidget {
  const CrearProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/736x/71/7d/ce/717dce3d21e998822a3ca37065b932d3.jpg'),
        ),
      ),
      child: Center(
        child: Text(
          'Crearproduct',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 223, 87, 87),
          ),
        ),
      ),
    );
  }
}
