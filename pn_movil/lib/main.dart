import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/conexiones/autentificacion.dart';
import 'package:pn_movil/models/Compras.dart';
import 'package:pn_movil/providers/clasificacion_provider.dart';
import 'package:pn_movil/providers/compra_provider.dart';
import 'package:pn_movil/providers/google_provider.dart';
import 'package:pn_movil/providers/inventario_provider.dart';
import 'package:pn_movil/providers/pago_provider.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/providers/user_provider.dart';
import 'package:pn_movil/services/AuthService.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar_crear.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar_editar.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar_detalle.dart';
import 'package:pn_movil/views/Facturacion/facturacion.dart';
import 'package:pn_movil/views/Facturacion/facturacion_crear.dart';
import 'package:pn_movil/views/Inventario/detalle_inventario.dart';
import 'package:pn_movil/views/Inventario/inventario.dart';
import 'package:pn_movil/views/Pago/crear_pago.dart';
import 'package:pn_movil/views/Pago/pago.dart';
import 'package:pn_movil/views/Productos/crear_product.dart';
import 'package:pn_movil/views/Login/login.dart';
import 'package:pn_movil/views/Productos/products.dart';
import 'package:pn_movil/views/Panel/vista_inicial.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Llamada asíncrona para obtener los medios iniciales
  // List<SharedMediaFile>? sharedMedia = await initializeSharedMedia();

  // runApp(MyApp(sharedMedia: sharedMedia));
}

// Future<List<SharedMediaFile>?> initializeSharedMedia() async {
//   try {
//     // Intentamos obtener los medios iniciales compartidos
//     List<SharedMediaFile> sharedMedia = await ReceiveSharingIntent.getInitialMedia();
//     return sharedMedia;
//   } catch (e) {
//     // Si hay un error, lo manejamos
//     print('Error al obtener los medios iniciales: $e');
//     return null;
//   }
// }

class MyApp extends StatelessWidget {
  final List<SharedMediaFile>? sharedMedia;

  const MyApp({Key? key, this.sharedMedia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      initialRoute: sharedMedia != null ? 'crear-pago' : 'login',
      routes: {
        'login': (_) => const Login(),
        'home': (_) => const VistaInicial(),
        'productos': (_) => const Products(),
        'crearProduct': (_) => const CrearProduct(),
        'compras-solicitar': (_) => const Compras(),
        'compras-solicitar-crear': (_) => SeleccionarProductos(),
        'compras-solicitar-editar': (_) => ComprasSolicitarEditar(),
        'compras-solicitar-detalle': (_) => const ComprasSolicitarDetalle(),
        'realizar-pago': (_) => const Pago(),
        'crear-pago': (_) => CrearPago(sharedMedia: sharedMedia),
        'inventario': (_) => const Inventario(),
        'detalle-inventario': (_) => const DetalleInventario(),
        'facturacion': (_) => const Facturacion(),
        'facturacion-crear': (_) => const FacturacionCrear(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          color: Color.fromARGB(255, 149, 10, 0),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 149, 10, 0),
          elevation: 0,
        ),
      ),
    );
  }
}
