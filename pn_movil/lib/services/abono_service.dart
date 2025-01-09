import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/abono_provider.dart';

class AbonoService extends ChangeNotifier {
  final ApiClient apiClient;

  AbonoService(this.apiClient);

  final List<Map<String, String>> _selectedCuotas = [];

  bool get hasSelectedCuotas => _selectedCuotas.isNotEmpty;

  // Función para agregar una cuota seleccionada
  void addCuotas(Map<String, String> cuota) {
    _selectedCuotas.add(cuota);
    notifyListeners();
    print('Cuotas seleccionadas actualizadas: $_selectedCuotas');
  }

  //Funcion para remover una cuota seleccionada
  void removeCuota(int idCuota) {
    _selectedCuotas.removeWhere((cuota) {
      final idCuotaStr = cuota['idCuota'];
      return idCuotaStr != null && int.parse(idCuotaStr) == idCuota;
    });
    notifyListeners();
    print("Cuotas seleccionadas actualizadas: $_selectedCuotas");
  }

  // Función para calcular la suma total de las cuotas seleccionadas
  double calcularTotalCuotas() {
    double total = 0.0;

    for (var cuota in _selectedCuotas) {
      final valorStr = cuota['valor'];
      if (valorStr != null) {
        total += double.parse(valorStr);
      }
    }

    print('Total $total');
    return total;
  }

  void distribuirPago(double totalPago) {
    double saldoRestante = totalPago;
    print("Saldo inicial a distribuir: $saldoRestante");

    for (int i = 0; i < _selectedCuotas.length; i++) {
      final cuota = _selectedCuotas[i];
      final saldoCuota = double.parse(cuota['saldo'] ?? '0');

      print("Cuota ${cuota['idCuota']} con saldo: $saldoCuota");

      double valorModificado = 0;

      if (saldoRestante > 0) {
        if (saldoCuota > 0) {
          if (saldoRestante >= saldoCuota) {
            valorModificado = saldoCuota;
            saldoRestante -= valorModificado;
          } else {
            valorModificado = saldoRestante;
            saldoRestante = 0;
          }

          print(
              "Distribuyendo ${valorModificado} a la cuota ${cuota['idCuota']}");
        }
      }

      cuota['valor'] = valorModificado.toStringAsFixed(0);
      cuota.remove('saldo');
      print("Valor asignado a la cuota ${cuota['idCuota']}: ${cuota['valor']}");
      print("Saldo restante: $saldoRestante");

      if (saldoRestante <= 0) break;
    }

    notifyListeners();
  }

  //Funcion para vaciar las cuotas seleccionadas
  void clearSelectedCuotas() {
    _selectedCuotas.clear();
    notifyListeners();
  }

  //Funcion para crear una aplicacion de abono normal
  Future<void> guardarAbono(
      BuildContext context, int idCliente, int idPagoCliente) async {
    final Map<String, dynamic> factura = {
      'idCliente': idCliente,
      'idPagoCliente': idPagoCliente,
      'cuotas': _selectedCuotas,
    };

    try {
      // await AbonoProvider(apiClient).createAbono(context, factura);
      print('Aplicacion de abono normal creada con exito');
      print(factura);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      if (kDebugMode) print(e);
    }
  }

  //Funcion para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
