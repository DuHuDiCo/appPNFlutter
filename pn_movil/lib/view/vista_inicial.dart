import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';

class VistaInicial extends StatelessWidget {
  const VistaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Inicial'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: const Center(
        child: Text(
          'Hola',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
