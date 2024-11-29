import 'package:flutter/material.dart';

class Producto {
  int cantidad;
  double costo;
  int idProducto;
  int idUsuario;
  bool estimarFlete;
  bool isDescuentoInicial;

  Producto({
    required this.cantidad,
    required this.costo,
    required this.idProducto,
    required this.idUsuario,
    required this.estimarFlete,
    required this.isDescuentoInicial,
  });

  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'costo': costo,
      'idProducto': idProducto,
      'idUsuario': idUsuario,
      'estimarFlete': estimarFlete,
      'isDescuentoInicial': isDescuentoInicial,
    };
  }
}

class Compra {
  double monto;
  int idProveedor;
  List<Producto> productos;
  double totalCompra;
  double totalPagar;

  Compra({
    required this.monto,
    required this.idProveedor,
    required this.productos,
    required this.totalCompra,
    required this.totalPagar,
  });

  Map<String, dynamic> toJson() {
    return {
      'monto': monto,
      'idProveedor': idProveedor,
      'productos': productos.map((p) => p.toJson()).toList(),
      'totalCompra': totalCompra,
      'totalPagar': totalPagar,
    };
  }
}

class CompraState extends ChangeNotifier {
  double monto = 0;
  int idProveedor = 0;
  List<Producto> productos = [];
  double totalCompra = 0;
  double totalPagar = 0;

  void setMonto(double value) {
    monto = value;
    notifyListeners();
  }

  void setIdProveedor(int value) {
    idProveedor = value;
    notifyListeners();
  }

  void addProducto(Producto producto) {
    productos.add(producto);
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'monto': monto,
      'idProveedor': idProveedor,
      'productos': productos.map((p) => p.toJson()).toList(),
      'totalCompra': totalCompra,
      'totalPagar': totalPagar,
    };
  }
}
