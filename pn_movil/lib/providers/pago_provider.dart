import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Pago/pago.dart';

class PagoProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  PagoProvider(this._apiClient);

  List<Map<String, dynamic>> _pago = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get pagos => _pago;
  bool get isLoading => _isLoading;

//Metodo para cargar las pagos
  Future<void> loadPagos(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pago');
      if (response.statusCode == 200) {
        _pago = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Pagos cargados: $_pago"); // Debuggin
      } else {
        throw Exception('Error al cargar pagos');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar pagos';
      print(_pago);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//Metodo para crear el pago
  Future<void> crearPago(
      BuildContext context, Map<String, dynamic> pago, File? imagen) async {
    final dio = Dio();

    final token = await _apiClient.getAuthToken();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    try {
      _isLoading = true;
      notifyListeners();

      final idCompra = pago['idCompra'];

      if (idCompra == null) {
        throw Exception('El ID de la compra no está disponible.');
      } else {
        print('ID de la compra: $idCompra');
      }

      final formData = FormData();

      // Agregar los campos del pago al FormData
      pago.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Agregar la imagen al FormData, si existe
      if (imagen != null) {
        final fileName = imagen.path.split('/').last;
        formData.files.add(MapEntry(
          'archivo',
          await MultipartFile.fromFile(
            imagen.path,
            filename: fileName,
          ),
        ));
      }

      final response = await dio.post(
        'https://apppn.duckdns.org/api/v1/pago/$idCompra',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final pagoCreado = response.data as Map<String, dynamic>;
        _pago.add(pagoCreado);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pago creado exitosamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Pago()),
        );
      } else {
        throw Exception('Error al crear el pago: ${response.data}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago: ${e.toString()}')),
      );
    }
  }

//Metodo para eliminar un pago
  Future<void> deletePago(BuildContext context, int pagoId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Buscar la compra que contiene el pago
      final compra = _pago.firstWhere(
        (c) =>
            c['pagos'] != null && c['pagos'].any((p) => p['idPago'] == pagoId),
        orElse: () => <String, dynamic>{},
      );

      if (compra == null) {
        throw Exception('Compra asociada al pago no encontrada');
      }

      // Acceder al idInventory desde la compra
      final idInventory = compra['productoCompras'][0]
              ['productoCompraInventory'][0]['inventory']['idInventory'] ??
          '0';
      final inventarioId = int.tryParse(idInventory) ?? 0;

      print('ID del Inventario: $inventarioId');

      // Realizar la petición para eliminar el pago
      final response =
          await _apiClient.delete('/api/v1/pago/$pagoId/$inventarioId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _pago.removeWhere((pago) => pago['idPago'] == pagoId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pago eliminado exitosamente')),
        );
      } else {
        throw Exception('Error al eliminar el pago: ${response.body}');
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
