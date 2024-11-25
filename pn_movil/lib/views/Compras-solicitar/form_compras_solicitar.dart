import 'package:flutter/material.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FormComprasSolicitar extends StatefulWidget {
  const FormComprasSolicitar({super.key});

  @override
  _FormularioCompraState createState() => _FormularioCompraState();
}

class _FormularioCompraState extends State<FormComprasSolicitar> {
  final TextEditingController _fechaController = TextEditingController();
  String? _proveedorSeleccionado;
  String? _vendedorSeleccionado;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProveedorProvider>(context, listen: false)
          .loadProveedores(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false)
          .loadUsuariosVendedores(context);
    });
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo de fecha
          TextField(
            controller: _fechaController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Fecha',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100]?.withOpacity(0.8),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _fechaController.text =
                      '${pickedDate.toLocal()}'.split(' ')[0];
                });
              }
            },
          ),
          const SizedBox(height: 20),
          Consumer<ProveedorProvider>(
            builder: (context, proveedorProvider, child) {
              if (proveedorProvider.isLoading) {
                return CircularProgressIndicator();
              }

              if (proveedorProvider.proveedores.isEmpty) {
                return Text("No hay proveedores disponibles");
              }

              final proveedores = proveedorProvider.proveedores;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Proveedor compra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100]?.withOpacity(0.8),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _proveedorSeleccionado,
                    hint: Text('Proveedor compra'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _proveedorSeleccionado = newValue;
                      });
                    },
                    items: proveedores.map((proveedor) {
                      return DropdownMenuItem<String>(
                        value: proveedor['proveedor'],
                        child: Text(proveedor['proveedor']),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Consumer<UserProvider>(
          //   builder: (context, userProvider, child) {
          //     if (userProvider.isLoading) {
          //       return const CircularProgressIndicator();
          //     }

          //     if (userProvider.usuarios.isEmpty) {
          //       return const Text("No hay vendedores disponibles");
          //     }

          //     final usuarios = userProvider.usuarios;

          //     final dropdownItems = usuarios.map((usuario) {
          //       return DropdownMenuItem<String>(
          //         value: usuario['id'].toString(),
          //         child: Text(usuario['nombre']),
          //       );
          //     }).toList();

          //     return Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 10),
          //       child: InputDecorator(
          //         decoration: InputDecoration(
          //           labelText: 'Selecciona un Vendedor',
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           filled: true,
          //           fillColor: Colors.grey[100]?.withOpacity(0.8),
          //           prefixIcon: const Icon(Icons.person),
          //         ),
          //         child: DropdownButton<String>(
          //           isExpanded: true,
          //           value: _proveedorSeleccionado,
          //           hint: const Text('Selecciona un vendedor'),
          //           onChanged: (String? newValue) {
          //             setState(() {
          //               _proveedorSeleccionado = newValue;
          //             });
          //           },
          //           items: dropdownItems,
          //         ),
          //       ),
          //     );
          //   },
          // ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
