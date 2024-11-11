import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[800],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Cabecera del Drawer
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
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Configuración',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'settings');
              },
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text(
                'Usuarios',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'about');
              },
            ),

            const Divider(color: Colors.white), // Separador visual

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
