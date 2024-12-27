import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[800],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[600],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Bienvenido!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                'Inicio',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'home');
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.business_sharp, color: Colors.white),
              title: const Text(
                'Gestion de productos',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.business_sharp, color: Colors.white),
                    title: const Text('Productos',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'productos');
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.business_sharp, color: Colors.white),
              title: const Text(
                'Gestion de pagos de clientes',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.business_sharp, color: Colors.white),
                    title: const Text('Pagos de clientes',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'pagos-clientes');
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.white),
              title: const Text(
                'Gestion de compras',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.money_off, color: Colors.white),
                    title: const Text('Solicitar pago de compras',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, 'compras-solicitar');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.money, color: Colors.white),
                    title: const Text('Realizar pago de compras',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'realizar-pago');
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.inventory, color: Colors.white),
              title: const Text(
                'Gestion de inventarios',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_rounded,
                        color: Colors.white),
                    title: const Text('Inventario',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'inventario');
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.receipt_long, color: Colors.white),
              title: const Text(
                'Gestion de facturaciones',
                style: TextStyle(color: Colors.white),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.receipt_long, color: Colors.white),
                    title: const Text('Facturaciones',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'facturacion');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.business_sharp, color: Colors.white),
                    title: const Text('Productos sin facturación',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, 'productos-sin-facturacion');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.signal_cellular_alt_sharp,
                        color: Colors.white),
                    title: const Text('Tipos de venta',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'tipo-venta');
                    },
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
