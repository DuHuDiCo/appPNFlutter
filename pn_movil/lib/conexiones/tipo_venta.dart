import 'package:http/http.dart' as http;
import 'dart:convert';

class TipoVentaController {
  final String _baseUrl = 'https://apppn.duckdns.org';

  Future<List<Map<String, dynamic>>> getTipoVenta() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/api/v1/ListarTipoVentas'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los tipos de venta');
    }
  }
}
