import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/tipo_venta_provider.dart';

class TipoVentaService {
  final ApiClient apiClient;

  TipoVentaService(this.apiClient);

  // Método para guardar el tipo de venta
  Future<void> guardarTipoVenta(
      BuildContext context, Map<String, dynamic> tipoVenta) async {
    try {
      await TipoVentaProvider(apiClient).crearTipoVenta(context, tipoVenta);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de venta agregado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el tipo de venta: $e')),
      );
    }
  }

  //Metodo para eliminar un tipo de venta
  Future<void> eliminarTipoVenta(BuildContext context, int tipoVentaId) async {
    try {
      await TipoVentaProvider(apiClient).deleteTipoVenta(context, tipoVentaId);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el tipo de venta: $e')),
      );
    }
  }
}
