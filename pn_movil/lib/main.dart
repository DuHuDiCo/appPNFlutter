import 'package:flutter/material.dart';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/views/Clasificacion-productos/clasificacion_product.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_crear_v2.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_solicitar.dart';
import 'package:pn_movil/views/Compras-solicitar/compras_crear_v1.dart';
import 'package:pn_movil/views/Productos/crear_product.dart';
import 'package:pn_movil/views/login.dart';
import 'package:pn_movil/views/Productos/products.dart';
import 'package:pn_movil/views/vista_inicial.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
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
          'compras-solicitar-crear-v1': (_) => const ComprasSolicitarCrearV1(),
          'compras-solicitar-crear-v2': (_) => const SeleccionarProductos(),
          'compras-solicitar-detalle': (_) => const ComprasSolicitarCrearV1(),
          'clasificacion-productos': (_) => const ClasificacionProduct(),
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
