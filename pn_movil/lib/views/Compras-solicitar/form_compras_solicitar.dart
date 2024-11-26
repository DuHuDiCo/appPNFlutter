import 'package:flutter/material.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FormComprasSolicitar extends StatefulWidget {
  const FormComprasSolicitar({super.key});

  get isFormValidNotifier => null;

  @override
  _FormularioCompraState createState() => _FormularioCompraState();
}

class _FormularioCompraState extends State<FormComprasSolicitar> {
  final TextEditingController _fechaController = TextEditingController();
  String? _proveedorSeleccionado;
  String? _vendedorSeleccionado;

  ValueNotifier<bool> _isFormValidNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProveedorProvider>(context, listen: false)
          .loadProveedores(context);
      Provider.of<UserProvider>(context, listen: false)
          .loadUsuariosVendedores(context);
    });

    _fechaController.addListener(_validateForm);
  }

  void _validateForm() {
    bool isValid = _fechaController.text.isNotEmpty &&
        _proveedorSeleccionado != null &&
        _vendedorSeleccionado != null;
    _isFormValidNotifier.value = isValid;
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _isFormValidNotifier.dispose();
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
                _validateForm();
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
                      _validateForm();
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
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
