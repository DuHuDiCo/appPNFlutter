import 'package:flutter/material.dart';

class FormComprasSolicitar extends StatefulWidget {
  const FormComprasSolicitar({super.key});

  @override
  _FormularioCompraState createState() => _FormularioCompraState();
}

class _FormularioCompraState extends State<FormComprasSolicitar> {
  final TextEditingController _fechaController = TextEditingController();
  String? _proveedorSeleccionado;
  String? _vendedorSeleccionado;

  final List<String> _proveedores = [
    'Proveedor 1',
    'Proveedor 2',
    'Proveedor 3'
  ];
  final List<String> _vendedores = ['Vendedor A', 'Vendedor B', 'Vendedor C'];

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
          // Campo de proveedor
          DropdownButtonFormField<String>(
            value: _proveedorSeleccionado,
            onChanged: (value) {
              setState(() {
                _proveedorSeleccionado = value;
              });
            },
            items: _proveedores
                .map((proveedor) =>
                    DropdownMenuItem(value: proveedor, child: Text(proveedor)))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Proveedor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100]?.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          // Campo de vendedor
          DropdownButtonFormField<String>(
            value: _vendedorSeleccionado,
            onChanged: (value) {
              setState(() {
                _vendedorSeleccionado = value;
              });
            },
            items: _vendedores
                .map((vendedor) =>
                    DropdownMenuItem(value: vendedor, child: Text(vendedor)))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Vendedor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100]?.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
