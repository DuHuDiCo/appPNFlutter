import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class FacturacionProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  FacturacionProvider(this._apiClient);

  List<Map<String, dynamic>> _facturas = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get facturas => _facturas;
  bool get isLoading => _isLoading;

//Metodo para cargar las facturaciones
  Future<void> loadFacturas(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/facturacion/');
      if (response.statusCode == 200) {
        _facturas = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Facturaciones cargadas: $_facturas");
      } else {
        throw Exception('Error al cargar facturaciones');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar facturaciones';
      print(_facturas);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo para crear una facturación
  Future<void> crearFactura(
      BuildContext context, Map<String, dynamic> factura) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
        '/api/v1/facturacion/',
        factura,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Factura creada exitosamente')),
        );

        await loadFacturas(context);
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
