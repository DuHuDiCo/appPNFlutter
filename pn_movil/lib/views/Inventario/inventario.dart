import 'package:flutter/material.dart';
import 'package:pn_movil/providers/inventario_provider.dart';
import 'package:provider/provider.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventarioProvider>(context, listen: false)
          .loadInventarios(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
      ),
      body: Consumer<InventarioProvider>(
        builder: (context, inventarioProvider, child) {
          if (inventarioProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: inventarioProvider.inventarios.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    inventarioProvider.inventarios[index]['producto']
                        ['producto'],
                  ),
                  subtitle: Text(
                    inventarioProvider.inventarios[index]['cantidad'],
                  ),
                  trailing: Text(
                    inventarioProvider.inventarios[index]['precio'].toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
