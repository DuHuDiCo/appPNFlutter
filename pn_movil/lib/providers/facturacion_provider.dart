import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Facturacion/facturacion.dart';
import 'package:pn_movil/views/Plan-pago/crear_plan_pago.dart';

class FacturacionProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  FacturacionProvider(this._apiClient);

  List<Map<String, dynamic>> _facturas = [];
  Map<String, dynamic> _filteredFacturacionesClientes = {}; // No es una lista

  bool _isLoading = false;

  List<Map<String, dynamic>> get facturas => _facturas;
  bool get isLoading => _isLoading;

  Map<String, dynamic> get filteredFacturacionesClientes =>
      _filteredFacturacionesClientes; // Cambio a lista

  // Método para actualizar las facturaciones filtradas
  void setFilteredFacturacionesClientes(Map<String, dynamic> facturaciones) {
    _filteredFacturacionesClientes = facturaciones;
    notifyListeners();
  }

  // Método para resetear los filtros de pagos
  void resetFiltrados() {
    _filteredFacturacionesClientes = {};
    notifyListeners();
  }

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
          MaterialPageRoute(builder: (context) => CrearPlanPago()),
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

  //Metodo para obtener las facturaciones por ID del cliente
  Future<void> obtenerFacturasPorCliente(
      BuildContext context, int idCliente) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/client/facturaciones/$idCliente');

      if (response.statusCode == 200) {
        _facturas = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Facturaciones cargadas: $_facturas');
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('No se encontraron facturaciones para este cliente.')),
        );
      } else {
        throw Exception('Error al cargar facturaciones');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      if (kDebugMode) print('Error al obtener facturaciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metodo para crear un plan de pago
  Future<void> crearPlanPago(BuildContext context,
      Map<String, dynamic> planPago, int idCliente, int idFacturacion) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
          '/api/v1/client/PlanPago?idClient=$idCliente&idFacturacion=$idFacturacion',
          planPago);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plan de pago creado exitosamente')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Facturacion()),
        );

        await loadFacturas(context);
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

  // Método para obtener el resumen de pagos por cliente
  Future<void> resumenDePagosPorClienteId(
      BuildContext context, int idCliente) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient
          .get('/facturacion/obtenerFacturacionByClient?idClient=$idCliente');

      if (response.statusCode == 200) {
        final facturasData =
            Map<String, dynamic>.from(json.decode(response.body));

        if (facturasData['cuentaDTOs'] != null &&
            facturasData['cuentaDTOs'].isNotEmpty) {
          // Asigna el mapa completo (que contiene cuentaDTOs)
          setFilteredFacturacionesClientes(facturasData);
          print('Facturaciones filtradas: $_filteredFacturacionesClientes');
        } else {
          _filteredFacturacionesClientes = {};
          throw Exception('No hay facturaciones para este cliente');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Facturacion cliente no encontrado');
      } else {
        throw Exception('Error al obtener la facturacion cliente');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      if (kDebugMode) print('Error al obtener facturaciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
