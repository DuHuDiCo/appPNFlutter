import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/pago_provider.dart';

class PagoService {
  final ApiClient apiClient;

  PagoService(this.apiClient);

  // Método para seleccionar una imagen
  Future<File?> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
      if (imagen != null) {
        return File(imagen.path);
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
    return null;
  }

  // Método para guardar el pago
  Future<void> guardarPago(BuildContext context, int idCompra,
      File? imagenSeleccionada, double totalPago) async {
    if (imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar una imagen antes de guardar.'),
        ),
      );
      return;
    }

    if (totalPago == 0 || totalPago.isNaN) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El total del pago no puede estar vacío.'),
        ),
      );
      return;
    }

    if (totalPago < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El total del pago no puede ser negativo.'),
        ),
      );
      return;
    }

    final Map<String, dynamic> pago = {
      'idCompra': idCompra,
      'totalPago': totalPago,
    };

    try {
      await PagoProvider(apiClient)
          .crearPago(context, pago, imagenSeleccionada);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago: $e')),
      );
    }
  }

  // Método para eliminar el pago
  Future<void> eliminarPago(BuildContext context, int pagoId) async {
    try {
      await PagoProvider(apiClient).deletePago(context, pagoId);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el pago: $e')),
      );
    }
  }

  // Método para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
