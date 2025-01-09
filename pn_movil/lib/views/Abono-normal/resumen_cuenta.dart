import 'package:flutter/material.dart';

class ResumenCuenta extends StatefulWidget {
  const ResumenCuenta({super.key});

  @override
  State<ResumenCuenta> createState() => _ResumenCuentaState();
}

class _ResumenCuentaState extends State<ResumenCuenta> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ResumenCuenta'),
      ),
    );
  }
}
