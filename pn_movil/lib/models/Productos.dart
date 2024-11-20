import 'package:dio/dio.dart';

class Productos {
  final String producto;
  final String descripcion;
  final int clasificacionProducto;

  Productos({
    required this.producto,
    required this.descripcion,
    required this.clasificacionProducto,
  });

  Map<String, dynamic> toMap() {
    return {
      'producto': producto,
      'descripcion': descripcion,
      'clasificacionProducto': clasificacionProducto,
    };
  }
}

class ClasificacionProducto {
  int idClasificacionProducto;
  String clasificacionProducto;

  ClasificacionProducto({
    required this.idClasificacionProducto,
    required this.clasificacionProducto,
  });
}
