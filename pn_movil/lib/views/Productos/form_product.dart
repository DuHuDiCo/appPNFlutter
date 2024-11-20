import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _descripcionController = TextEditingController();

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
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _addProduct(BuildContext context) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    if (_titleController.text.isEmpty ||
        _clasificacionController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos los campos deben ser completados")),
      );
      return;
    }

    // Validar clasificación
    int? clasificacionProducto = int.tryParse(_clasificacionController.text);
    if (clasificacionProducto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La clasificación debe ser un número válido")),
      );
      return;
    }

    // Preparar FormData
    final imagenFile = MultipartFile.fromFileSync(
      _image!.path,
      filename: _image!.path.split('/').last,
    );

    print("Ruta del archivo: ${_image!.path}");

    final formData = FormData.fromMap({
      'producto': _titleController.text,
      'descripcion': _descripcionController.text,
      'clasificacionProducto': clasificacionProducto,
      'imagen': imagenFile,
    });

    print(formData);

    // Intentar guardar el producto
    try {
      await productsProvider.addProduct(context, formData);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar el producto: $error")),
      );
    }
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
          controller: _clasificacionController,
          keyboardType: TextInputType.number,
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
          controller: _descripcionController,
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
            _addProduct(context);
            Navigator.pushReplacementNamed(context, 'productos');
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
