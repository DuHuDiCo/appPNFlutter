import 'package:flutter/material.dart';
import 'package:pn_movil/providers/compra_provider.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/providers/user_provider.dart';
import 'package:pn_movil/widgets/botton_CP.dart';
import 'package:provider/provider.dart';

class FormComprasSolicitar extends StatefulWidget {
  const FormComprasSolicitar({super.key});

  @override
  _FormularioCompraState createState() => _FormularioCompraState();
}

class _FormularioCompraState extends State<FormComprasSolicitar> {
  final TextEditingController _fechaController = TextEditingController();
  String? _proveedorSeleccionado;

  final List<Map<String, dynamic>> compras = [];

  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProveedorProvider>(context, listen: false)
          .loadProveedores(context);
      Provider.of<UserProvider>(context, listen: false)
          .loadUsuariosVendedores(context);
    });

    _fechaController.addListener(_validateForm);
  }

  void _validateForm() {
    bool isValid =
        _fechaController.text.isNotEmpty && _proveedorSeleccionado != null;
    _isFormValidNotifier.value = isValid;
  }

  void _saveFormData() {
    if (_fechaController.text.isNotEmpty && _proveedorSeleccionado != null) {
      // Almacena los datos en el Map
      Map<String, dynamic> compraData = {
        'nuevaFecha': _fechaController.text,
        'proveedor': _proveedorSeleccionado,
      };

      // Agregar los datos a la lista
      setState(() {
        compras.add(compraData); // Agregar la nueva compra a la lista
      });

      print('Datos almacenados: $compras');
    } else {
      print('Formulario no válido');
    }
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
                Provider.of<CompraProvider>(context, listen: false)
                    .setFecha(_fechaController.text);
              }
            },
          ),
          const SizedBox(height: 20),

          // Campo para seleccionar el proveedor
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
                      if (newValue != null) {
                        Provider.of<CompraProvider>(context, listen: false)
                            .setProveedor(newValue);
                      }
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


  // // Botón para guardar el formulario
  //         ValueListenableBuilder<bool>(
  //           valueListenable: _isFormValidNotifier,
  //           builder: (context, isFormValid, child) {
  //             return ElevatedButton(
  //               onPressed: isFormValid
  //                   ? () {
  //                       // Acciones a realizar cuando el formulario sea válido
  //                       print('Formulario válido, proceder a guardar...');
  //                       print(_fechaController.text);
  //                       print(_proveedorSeleccionado);
  //                     }
  //                   : null,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.blue.shade700,
  //                 disabledBackgroundColor:
  //                     Colors.blue.shade200.withOpacity(0.38),
  //               ),
  //               child: const Text('Guardar'),
  //             );
  //           },
  //         ),
