import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar.dart';

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

//Metodo para crear la compra
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        final compraCreada = json.decode(response.body) as Map<String, dynamic>;
        _compras.add(compraCreada);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra creada exitosamente')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Compras()),
        );
      } else {
        throw Exception('Error al crear la compra: ${response.body}');
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metodo para editar la compra
  Future<void> editarCompra(
      BuildContext context, Map<String, dynamic> editarCompra) async {
    try {
      _isLoading = true;
      notifyListeners();

      final idCompra = editarCompra['idCompra'];

      if (idCompra == null) {
        throw Exception('El ID de la compra no está disponible.');
      } else {
        print('ID de la compra: $idCompra');
      }

      final response = await _apiClient.put(
        '/compra/$idCompra',
        editarCompra,
      );

      print('Respuesta del backend: ${response.body}');
      print(editarCompra);

      if (response.statusCode == 200) {
        final compraEditada =
            json.decode(response.body) as Map<String, dynamic>;

        final index = _compras.indexWhere(
            (compra) => compra['idCompra'] == compraEditada['idCompra']);
        if (index != -1) {
          _compras[index] = compraEditada;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra editada exitosamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Compras()),
        );
      } else {
        throw Exception('Error al editar la compra: ${response.body}');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error inesperado: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para agregar un flete a la compra
  Future<void> agregarFlete(
      BuildContext context, Map<String, dynamic> flete, int idCompra) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.put(
        '/api/v1/compra/flete/$idCompra',
        flete,
      );

      print('Respuesta del backend: ${response.body}');
      print(editarCompra);

      if (response.statusCode == 200) {
        final compraEditada =
            json.decode(response.body) as Map<String, dynamic>;

        final index = _compras.indexWhere(
            (compra) => compra['idCompra'] == compraEditada['idCompra']);
        if (index != -1) {
          _compras[index] = compraEditada;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra editada exitosamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Compras()),
        );
      } else {
        throw Exception('Error al editar la compra: ${response.body}');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error inesperado: ${e.toString()}';

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
