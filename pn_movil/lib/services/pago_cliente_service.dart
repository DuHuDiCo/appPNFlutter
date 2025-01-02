import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/pago_cliente_provider.dart';

class PagoClienteService {
  final ApiClient apiClient;
  Map<String, dynamic>? aplicarPago;

  PagoClienteService(this.apiClient);

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

// Método para guardar el pago de cliente
  Future<void> guardarPagoCliente(
      BuildContext context,
      File? imagenSeleccionada,
      double valor,
      String numeroRecibo,
      String tipoPago,
      {Map<String, dynamic>? aplicarPago}) async {
    // Validar si se seleccionó una imagen
    if (imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar una imagen antes de guardar.'),
        ),
      );
      return;
    }

    // Construir aplicarPagoDTO solo si aplicarPago no es nulo y contiene datos
    List<Map<String, dynamic>>? aplicarPagoDTO;
    if (aplicarPago != null && aplicarPago.isNotEmpty) {
      aplicarPagoDTO = [aplicarPago];
    }

    try {
      await PagoClienteProvider(apiClient).crearPagoCliente(
        context,
        valor,
        numeroRecibo,
        tipoPago,
        aplicarPagoDTO,
        imagenSeleccionada,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago del cliente: $e')),
      );
    }
  }
}


    // if (valor == 0 || valor.isNaN) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('El total del pago no puede estar vacío.'),
    //     ),
    //   );
    //   return;
    // }

    // if (valor < 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('El total del pago no puede ser negativo.'),
    //     ),
    //   );
    //   return;
    // }

    // if (numeroRecibo.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('El total del pago no puede estar vacío.'),
    //     ),
    //   );
    //   return;
    // }

    // if (tipoPago.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('El total del pago no puede estar vacío.'),
    //     ),
    //   );
    //   return;
    // }