import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/pago_provider.dart';

class PagoService {
  final ApiClient apiClient;

  // Constructor que acepta una instancia de ApiClient
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

    final Map<String, dynamic> pago = {
      'idCompra': idCompra,
      'totalPago': totalPago,
    };

    // Llamar al método de crearPago desde PagoProvider
    try {
      await PagoProvider(apiClient)
          .crearPago(context, pago, imagenSeleccionada);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago: $e')),
      );
    }
  }
}
