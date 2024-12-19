import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Facturacion/facturacion.dart';

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

      final idUser = 0;

      final response = await _apiClient.get('/facturacion/?idUser=$idUser');
      if (response.statusCode == 200) {
        _facturas = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Facturaciones cargadas: $_facturas");
      } else {
        throw Exception('Error al cargar facturaciones');
      }
    } catch (e) {
      print(_facturas);
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Facturacion()),
        );

        await loadFacturas(context);
      } else {
        throw Exception('Error al crear facturación');
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
