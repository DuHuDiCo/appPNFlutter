import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class CompraProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  CompraProvider(this._apiClient);

  List<Map<String, dynamic>> _compras = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get compras => _compras;
  bool get isLoading => _isLoading;

//Metodo para cargar las compras
  Future<void> loadCompras(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/compra/compras');
      if (response.statusCode == 200) {
        _compras = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Compras cargadas: $_compras"); // Debugging
      } else {
        throw Exception('Error al cargar compras');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar compras';
      print(_compras);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? proveedor;

  void setProveedor(String nuevoProveedor) {
    proveedor = nuevoProveedor;
    notifyListeners();
  }

  bool get isValid => proveedor != null;

  Future<void> createCompra(
      BuildContext context, Map<String, dynamic> nuevaCompra) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
        '/compra/',
        nuevaCompra,
      );

      print('Respuesta del backend: ${response.body}');
      print(nuevaCompra);

      if (response.statusCode == 201) {
        final compraCreada = json.decode(response.body) as Map<String, dynamic>;
        _compras.add(compraCreada);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra creada exitosamente')),
        );
      } else {
        throw Exception('Error al crear la compra: ${response.body}');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al crear la compra';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
