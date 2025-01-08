import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
    // Construir aplicarPagoDTO solo si aplicarPago no es nulo y contiene datos
    List<Map<String, dynamic>>? aplicarPagoDTO;
    if (aplicarPago != null && aplicarPago.isNotEmpty) {
      aplicarPagoDTO = [aplicarPago];
    }

    if (imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar una imagen antes de guardar.'),
        ),
      );
      return;
    }

    if (valor == 0 || valor.isNaN) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El total del pago no puede estar vacío.'),
        ),
      );
      return;
    }

    if (valor < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El total del pago no puede ser negativo.'),
        ),
      );
      return;
    }

    if (numeroRecibo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El numero de recibo no puede estar vacío.'),
        ),
      );
      return;
    }

    if (tipoPago.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El tipo de pago no puede estar vacío.'),
        ),
      );
      return;
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
        SnackBar(content: Text('Error al crear el pago del cliente 3: $e')),
      );
    }
  }

  //Metodo para aplicar el pago automático
  Future<void> aplicarPagoAutomatico(BuildContext context, int idPagoCliente,
      {Map<String, dynamic>? aplicarPago}) async {
    List<Map<String, dynamic>>? aplicarPagoDTO;
    if (aplicarPago != null && aplicarPago.isNotEmpty) {
      aplicarPagoDTO = [aplicarPago];
    }

    try {
      await PagoClienteProvider(apiClient).aplicarPagoAutomatico(
        context,
        idPagoCliente,
        aplicarPagoDTO: aplicarPagoDTO,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el pago del cliente 3: $e')),
      );
    }
  }

  //Metodo para formatear el valor de un pago a COP
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }

  //Metodo para eliminar un pago del cliente
  Future<void> eliminarpagoCliente(
      BuildContext context, int pagoClienteId) async {
    try {
      await PagoClienteProvider(apiClient)
          .deletePagoCliente(context, pagoClienteId);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el pago del cliente: $e')),
      );
    }
  }
}
