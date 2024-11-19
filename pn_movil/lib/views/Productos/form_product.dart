import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pn_movil/conexiones/apiClient.dart';
import 'package:pn_movil/models/Productos.dart';
import 'dart:io';

import 'package:pn_movil/providers/products_provider.dart';
import 'package:provider/provider.dart';

class FormularioProducto extends StatefulWidget {
  const FormularioProducto({super.key});

  @override
  _FormularioProductoState createState() => _FormularioProductoState();
}

class _FormularioProductoState extends State<FormularioProducto> {
  XFile? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _clasificacionController =
      TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Método para seleccionar una imagen
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _addProduct(BuildContext context) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    final token = await productsProvider.getAuthToken();

    // Verificar que todos los campos estén completos
    if (_titleController.text.isEmpty ||
        _clasificacionController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos los campos deben ser completados")),
      );
      return;
    }

    // Convertir imagen a MultipartFile
    final imagenFile = await MultipartFile.fromFile(
      _image!.path,
      filename: _image!.path.split('/').last, // Extrae el nombre del archivo
    );

    // Crear el objeto Producto con MultipartFile
    final product = Productos(
      producto: _titleController.text,
      description: _descriptionController.text,
      imagen: imagenFile,
      clasificacionProducto: 1, // Cambia según el valor real de clasificación
    );

    // Verificar los datos que se enviarán
    print('Producto a enviar: ${product.toMap()}');

    // Convertir a Map<String, dynamic>
    final productMap = product.toMap();

    // Llamar al método del proveedor para agregar el producto
    await productsProvider.addProduct(
      context,
      token!,
      productMap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    _image != null ? FileImage(File(_image!.path)) : null,
              ),
              if (_image == null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.image,
                      size: 35,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Subir Imagen',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller:
              _clasificacionController, // Nuevo controlador para la clasificación
          decoration: InputDecoration(
            labelText: 'Clasificación del Producto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100]?.withOpacity(0.8),
            prefixIcon: const Icon(Icons.category),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller:
              _titleController, // Asegúrate de usar otro controlador para este campo si es necesario
          decoration: InputDecoration(
            labelText: 'Título del Producto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100]?.withOpacity(0.8),
            prefixIcon: const Icon(Icons.title),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _precioController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Precio del Producto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100]?.withOpacity(0.8),
            prefixIcon: const Icon(Icons.monetization_on),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Descripción del Producto',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100]?.withOpacity(0.8),
            prefixIcon: const Icon(Icons.description),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            _addProduct(context); // Llamar al método para agregar el producto
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color.fromARGB(255, 90, 136, 204),
          ),
          child: const Text(
            'Guardar Producto',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
