import 'package:flutter/material.dart';
import 'package:pn_movil/widgets/drawer.dart';
import 'package:pn_movil/widgets/navbar.dart';

class VistaInicial extends StatelessWidget {
  const VistaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildModuleCard(
                    icon: Icons.people,
                    label: 'Usuarios',
                    color: Colors.blue,
                    statsLabel: 'Activos',
                    statsValue: '50',
                    onTap: () {},
                  ),
                  _buildModuleCard(
                    icon: Icons.shopping_cart_checkout,
                    label: 'Vendedores',
                    color: Colors.green,
                    statsLabel: 'Activos',
                    statsValue: '21',
                    onTap: () {},
                  ),
                  _buildModuleCard(
                    icon: Icons.local_shipping,
                    label: 'Proveedores',
                    color: Colors.teal,
                    statsLabel: 'Registrados',
                    statsValue: '15',
                    onTap: () {},
                  ),
                  _buildModuleCard(
                    icon: Icons.inventory,
                    label: 'Inventario',
                    color: Colors.orange,
                    statsLabel: 'Productos',
                    statsValue: '120',
                    onTap: () {},
                  ),
                  _buildModuleCard(
                    icon: Icons.analytics,
                    label: 'Solicitudes',
                    color: Colors.purple,
                    statsLabel: 'Registradas',
                    statsValue: '20',
                    onTap: () {},
                  ),
                  _buildModuleCard(
                    icon: Icons.attach_money,
                    label: 'Pagos',
                    color: Colors.redAccent,
                    statsLabel: 'Realizados',
                    statsValue: '10',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required IconData icon,
    required String label,
    required Color color,
    required String statsLabel,
    required String statsValue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                statsValue,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                statsLabel,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
