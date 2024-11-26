import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class Pago extends StatelessWidget {
  const Pago({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Text('Pago'),
      ),
    );
  }
}
