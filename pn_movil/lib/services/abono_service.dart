import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

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

  //Funcion para vaciar las cuotas seleccionadas
  void clearSelectedCuotas() {
    _selectedCuotas.clear();
    notifyListeners();
  }

  // Función para calcular la suma total de las cuotas seleccionadas
  double calcularTotalCuotas() {
    double total = 0.0;

    for (var cuota in _selectedCuotas) {
      final valorStr = cuota['saldo'];
      if (valorStr != null) {
        total += double.parse(valorStr);
      }
    }

    print('Total $total');
    return total;
  }

// Método para distribuir el pago entre las cuotas seleccionadas
  void distribuirPago(double totalPago) {
    double saldoRestante = totalPago;
    print("Saldo inicial a distribuir: $saldoRestante");

    // Primero, recalcular el valor de las cuotas, si es necesario
    for (int i = 0; i < _selectedCuotas.length; i++) {
      final cuota = _selectedCuotas[i];
      final saldoCuota = double.parse(cuota['saldo'] ?? '0');
      cuota['valor'] = saldoCuota
          .toStringAsFixed(0); // Recalcular el valor antes de distribuir
    }

    for (int i = 0; i < _selectedCuotas.length; i++) {
      final cuota = _selectedCuotas[i];
      final saldoCuota = double.parse(cuota['saldo'] ?? '0');
      double valorModificado = 0;

      print("Cuota ${cuota['idCuota']} con saldo: $saldoCuota");

      if (saldoRestante > 0) {
        if (saldoCuota > 0) {
          if (saldoRestante >= saldoCuota) {
            valorModificado = saldoCuota; // Asignamos todo el saldo de la cuota
            saldoRestante -= valorModificado;
          } else {
            valorModificado = saldoRestante; // Asignamos el saldo restante
            saldoRestante = 0;
          }
          cuota['valor'] = valorModificado.toStringAsFixed(0);
          print(
              "Distribuyendo ${valorModificado} a la cuota ${cuota['idCuota']}");
        }
      }

      print("Valor asignado a la cuota ${cuota['idCuota']}: ${cuota['valor']}");
      print("Saldo restante: $saldoRestante");

      if (saldoRestante <= 0) {
        print("Saldo restante ya es 0, terminando distribución.");
        break;
      }
    }
    notifyListeners();
  }

// Funcion para crear una aplicacion de abono normal
  Future<void> guardarAbono(
      BuildContext context, int idCliente, int idPagoCliente) async {
    List<Map<String, String>> cuotasSinSaldo = _selectedCuotas.map((cuota) {
      var cuotaSinSaldo = Map<String, String>.from(cuota);
      cuotaSinSaldo.remove('saldo');
      return cuotaSinSaldo;
    }).toList();

    for (var cuota in cuotasSinSaldo) {
      if (cuota['valor'] == '0') {
        final cuotaOriginal = _selectedCuotas.firstWhere(
          (originalCuota) => originalCuota['idCuota'] == cuota['idCuota'],
          orElse: () => {},
        );
        if (cuotaOriginal != null && cuotaOriginal.isNotEmpty) {
          double saldoOriginal = double.parse(cuotaOriginal['saldo'] ?? '0');
          cuota['valor'] = saldoOriginal.toStringAsFixed(0);
        }
      }
    }

    final Map<String, dynamic> factura = {
      'idCliente': idCliente,
      'idPagoCliente': idPagoCliente,
      'cuotas': cuotasSinSaldo,
    };

    try {
      // await AbonoProvider(apiClient).createAbono(context, factura);
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
