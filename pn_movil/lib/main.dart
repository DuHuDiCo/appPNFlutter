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
import 'package:pn_movil/views/Inventario/inventario.dart';
import 'package:pn_movil/views/Pago/crear_pago.dart';
import 'package:pn_movil/views/Pago/pago.dart';
import 'package:pn_movil/views/Productos/crear_product.dart';
import 'package:pn_movil/views/Login/login.dart';
import 'package:pn_movil/views/Productos/products.dart';
import 'package:pn_movil/views/Panel/vista_inicial.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient('https://apppn.duckdns.org/api/v1'),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider(create: (_) => CompraState()),
        ChangeNotifierProvider<ProductsProvider>(
          create: (context) => ProductsProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<ClasificacionProvider>(
          create: (context) => ClasificacionProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<CompraProvider>(
          create: (context) => CompraProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<ProveedorProvider>(
          create: (context) => ProveedorProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<PagoProvider>(
          create: (context) => PagoProvider(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<InventarioProvider>(
          create: (context) => InventarioProvider(context.read<ApiClient>()),
        ),
        Provider<GoogleAuthController>(
          create: (_) => GoogleAuthController(),
        ),
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(
            context.read<AuthService>(),
            context.read<GoogleAuthController>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        initialRoute: 'login',
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
          'crear-pago': (_) => const CrearPago(),
          'inventario': (_) => const Inventario(),
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
      ),
    );
  }
}
