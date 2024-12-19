import 'dart:math';

import 'package:flutter/material.dart';

class ProductCardEdit extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final int cantidad;
  final String clasification;
  final int cantidad;
  final double precio;
  final int productId;
  final int productIdCompra;
  final void Function(
          String productName, int cantidad, double precio, int productId)
      onEditProduct;
  final void Function(String productName, int productIdCompra) onRemoveProduct;

  const ProductCardEdit({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.cantidad,
    required this.clasification,
    required this.onRemoveProduct,
    required this.productId,
    required this.onEditProduct,
    required this.cantidad,
    required this.precio,
    required this.productIdCompra,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 210, 215, 219),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.38,
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _getImageProvider(),
              ),
              const SizedBox(height: 10),
              Text(
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                clasification,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        onEditProduct(productName, cantidad, precio, productId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(), // Botón circular
                      padding: const EdgeInsets.all(8), // Ajusta el tamaño
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => onRemoveProduct(productName, productId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(), // Botón circular
                      padding: const EdgeInsets.all(8), // Ajusta el tamaño
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }
}
