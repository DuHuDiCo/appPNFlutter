import 'package:flutter/material.dart';
import 'package:pn_movil/providers/proveedor_provider.dart';
import 'package:pn_movil/widgets/Components-cards/card_container.dart';
import 'package:pn_movil/widgets/Components-cards/cards_select_products.dart';
import 'package:pn_movil/widgets/Components-navbar/drawer.dart';
import 'package:pn_movil/widgets/Components-navbar/navbar.dart';
import 'package:provider/provider.dart';

class ComprasSolicitarEditar extends StatelessWidget {
  ComprasSolicitarEditar({super.key});

//Funcion para crear el cuerpo del dialogo de agregar producto
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? compra =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: const Navbar(),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  ProductCardSelect(
                    imageUrl: 'assets/algo.jpg',
                    productName: 'Producto A',
                    clasification: 'Clasificación A',
                    onAddProduct: (productName, clasification, productId) {
                      _showAddProductDialog(
                          context, productName, clasification, productId);
                    },
                    isSelected: false,
                    productId: '1',
                    onRemoveProduct:
                        (String productName, String clasification) {},
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

//Funcion para crear el header del dialogo de agregar producto
  Widget _buildHeader() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: CardContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.blue.shade800,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Editar Compra',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Consumer<ProveedorProvider>(
                  builder: (context, proveedorProvider, child) {
                    if (proveedorProvider.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    final proveedores = proveedorProvider.proveedores;
                    return DropdownButtonFormField<int>(
                      isExpanded: true,
                      // value: _proveedorSeleccionado,
                      decoration: InputDecoration(
                        labelText: 'Proveedor compra',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {},
                      items: proveedores.map((proveedor) {
                        return DropdownMenuItem<int>(
                          value: proveedor['idProveedor'],
                          child: Text(proveedor['proveedor']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue.shade800,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Agregar Productos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(112, 185, 244, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  //Dialogo para agregar producto
  Future<void> _showAddProductDialog(BuildContext context, String productName,
      String clasification, String productId) async {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController costoController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Agregar Producto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cantidadController,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.shopping_cart),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: costoController,
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 129, 121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Agregar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Boton para guardar los datos del formulario
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Editar compra',
                style: TextStyle(
                  color: Color.fromARGB(255, 244, 245, 246),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
