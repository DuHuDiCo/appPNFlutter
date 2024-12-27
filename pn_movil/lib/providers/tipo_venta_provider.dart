import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Tipo-venta/tipo_venta.dart';

class TipoVentaProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  TipoVentaProvider(this._apiClient);

  List<Map<String, dynamic>> _tipoVenta = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get tipoVenta => _tipoVenta;
  bool get isLoading => _isLoading;

  Future<void> loadTipoVenta(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/tipoVenta/tipoVentas');
      if (response.statusCode == 200) {
        _tipoVenta =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al cargar los tipos de venta');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar los tipos de venta';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo paa crear un tipo de venta
  Future<void> crearTipoVenta(
      BuildContext context, Map<String, dynamic> tipoVenta) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post('/api/v1/tipoVenta/', tipoVenta);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tipo de venta creado exitosamente')),
        );

        await loadTipoVenta(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo para eliminar un pago
  Future<void> deleteTipoVenta(BuildContext context, int tipoVentaId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response =
          await _apiClient.delete('/api/v1/tipoVenta/$tipoVentaId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Eliminar el pago de la lista localmente
        _tipoVenta.removeWhere((tipo) => tipo['idTipoVenta'] == tipoVentaId);
      } else {
        throw Exception('Error al eliminar el tipo de venta: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
