// import 'package:flutter/material.dart';
// import 'package:pn_movil/providers/compra_provider.dart';
// import 'package:provider/provider.dart';

// class GuardarProductos extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Obtener los valores almacenados en CompraProvider
//     final compra = Provider.of<CompraProvider>(context).compras;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vista de Productos'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Fecha seleccionada: ${compra.nuevaFecha ?? 'No seleccionada'}'),
//             Text('Proveedor: ${compra.nuevoProveedor?? 'No seleccionado'}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

