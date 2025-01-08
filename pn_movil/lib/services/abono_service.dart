import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';

class AbonoService {
  AbonoService(ApiClient apiClient);

  //Funcion para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
