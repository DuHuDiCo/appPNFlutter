import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pn_movil/providers/clasificacion_provider.dart';
import 'dart:io';
import 'package:pn_movil/providers/products_provider.dart';
import 'package:pn_movil/views/Productos/crear_product.dart';
import 'package:pn_movil/views/Productos/products.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

class FormularioProducto extends StatefulWidget {
  const FormularioProducto({super.key});

  @override
  _FormularioProductoState createState() => _FormularioProductoState();
}

class _FormularioProductoState extends State<FormularioProducto> {
  XFile? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  int? _selectedClasificacion;

  @override
  void initState() {
    super.initState();
    // Cargar las clasificaciones al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClasificacionProvider>(context, listen: false)
          .loadClasificaciones(context);
    });
  }

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

    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    // Validar que todos los campos están llenos
    if (_titleController.text.isEmpty ||
        _selectedClasificacion == null ||
        _descripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos los campos deben ser completados")),
      );
      return;
    }

    var formData = FormData();

    if (_image != null) {
      // Convertir imagen a MultipartFile
      final imagenFile = await MultipartFile.fromFile(
        _image!.path,
        filename: _image!.path.split('/').last,
      );

      formData = FormData.fromMap({
        'producto': _titleController.text,
        'descripcion': _descripcionController.text,
        'imagen': imagenFile,
        'clasificacionProducto': _selectedClasificacion,
      });
    } else {
      formData = FormData.fromMap({
        'producto': _titleController.text,
        'descripcion': _descripcionController.text,
        'clasificacionProducto': _selectedClasificacion,
      });
    }

    try {
      await productsProvider.addProduct(
        context,
        formData,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Producto guardado exitosamente")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Products()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar el producto: $error")),
      );
    }
  }

// Función que mueve el archivo a un directorio más accesible
  Future<File> moveFileToDocumentsDirectory(File image) async {
    try {
      // Obtén la ruta del directorio de documentos de la aplicación
      final directory = await getApplicationDocumentsDirectory();
      // Crea una nueva ruta en el directorio de documentos con el mismo nombre de archivo
      final newPath = '${directory.path}/${image.path.split('/').last}';
      // Mueve el archivo desde la ruta original a la nueva ruta
      final newFile = await image.copy(newPath);

      print("Nuevo archivo en: $newPath");

      // Devuelve el nuevo archivo
      return newFile;
    } catch (e) {
      print("Error al mover el archivo: $e");
      rethrow;
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
        Consumer<ClasificacionProvider>(
          builder: (context, clasificacionProvider, child) {
            if (clasificacionProvider.isLoading) {
              return CircularProgressIndicator(); // Mostrar mientras carga
            }

            if (clasificacionProvider.clasificaciones.isEmpty) {
              return Text("No hay clasificaciones disponibles");
            }

            final clasificaciones = clasificacionProvider.clasificaciones;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Clasificación del Producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100]?.withOpacity(0.8),
                  prefixIcon: const Icon(Icons.category),
                ),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedClasificacion,
                  hint: Text('Clasificación producto'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedClasificacion = newValue;
                    });
                  },
                  items: clasificaciones.map((clasificacion) {
                    return DropdownMenuItem<int>(
                      value: clasificacion['idClasificacionProducto'],
                      child: Text(clasificacion['clasificacionProducto']),
                    );
                  }).toList(),
                ),
              ),
            );
          },
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
