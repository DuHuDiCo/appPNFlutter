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
  // Future<void> deletePago(BuildContext context, int pagoId) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();

  //     final response = await _apiClient.delete('/api/v1/pago/$pagoId');

  //     if (response.statusCode == 200 || response.statusCode == 204) {
  //       // Eliminar el pago de la lista localmente
  //       _pago.removeWhere((pago) => pago['idPago'] == pagoId);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Pago eliminado exitosamente')),
  //       );
  //     } else {
  //       throw Exception('Error al eliminar el pago: ${response.body}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //     if (kDebugMode) print(e);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> deletePago(BuildContext context, int pagoId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Imprimir toda la lista de pagos para depuración
      print('Lista de pagos: $_pago');

      // Buscar la compra que contiene el pago
      final compra = _pago.firstWhere(
        (c) => c['pago'] != null && c['pago']['idPago'] == pagoId,
        orElse: () {
          print('Compra no encontrada para el pago con ID: $pagoId');
          return {}; // Retorna null si no encuentra la compra
        },
      );

      if (compra == null) {
        throw Exception('Compra asociada al pago no encontrada');
      }

      // Imprimir la compra encontrada
      print('Compra encontrada: $compra');

      // Validar que 'productoCompras' esté presente y no esté vacío
      final productoCompras = compra['productoCompras'];
      if (productoCompras == null || productoCompras.isEmpty) {
        print('productoCompras: $productoCompras');
        throw Exception('ProductoCompras no disponible o vacío');
      }

      // Imprimir los productos de compra
      print('ProductoCompras: $productoCompras');

      // Acceder al primer elemento de 'productoCompras'
      final productoCompra = productoCompras[0];

      // Validar que 'productoCompraInventory' esté presente y no esté vacío
      final productoCompraInventory = productoCompra['productoCompraInventory'];
      if (productoCompraInventory == null || productoCompraInventory.isEmpty) {
        print('productoCompraInventory: $productoCompraInventory');
        throw Exception('ProductoCompraInventory no disponible o vacío');
      }

      // Imprimir el inventario del producto de compra
      print('ProductoCompraInventory: $productoCompraInventory');

      // Acceder al primer elemento de 'productoCompraInventory'
      final inventory = productoCompraInventory[0]['inventory'];

      // Validar que 'inventory' no sea null y que contenga 'idInventory'
      if (inventory == null || inventory['idInventory'] == null) {
        print('inventory: $inventory');
        throw Exception(
            'Inventory no disponible o el campo idInventory es nulo');
      }

      // Obtener idInventory como entero
      final idInventory = inventory['idInventory'];
      final inventarioId = int.tryParse(idInventory.toString()) ?? 0;

      print('ID del Inventario: $inventarioId');

      // Construir la URL con el pagoId y el idInventario como query
      final url = '/api/v1/pago/$pagoId?idInventario=$inventarioId';

      // Realizar la petición para eliminar el pago
      final response = await _apiClient.delete(url);

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
