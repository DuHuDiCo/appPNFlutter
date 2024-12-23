import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';

class PagosClientes extends StatelessWidget {
  const PagosClientes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text('PagosClientes'),
      ),
    );
  }
}
