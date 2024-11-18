import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormularioProducto extends StatefulWidget {
  const FormularioProducto({super.key});

  @override
  _FormularioProductoState createState() => _FormularioProductoState();
}

class _FormularioProductoState extends State<FormularioProducto> {
  XFile? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
    super.dispose();
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
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Clasificacion del Producto',
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
          controller: _titleController,
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
          controller: _titleController,
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
            String title = _titleController.text;
            String description = _descriptionController.text;
            if (kDebugMode) {
              print('Título: $title');
            }
            if (kDebugMode) {
              print('Descripción: $description');
            }
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
