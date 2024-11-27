import 'dart:ffi';

import 'package:flutter/material.dart';

class ProductCardSelect extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String clasification;
  final String productId;
  final void Function(
      String clasification, String productName, String productId) onAddProduct;
  final bool isSelected;

  const ProductCardSelect({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.clasification,
    required this.onAddProduct,
    required this.isSelected,
    required this.productId,
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
              ElevatedButton(
                onPressed: isSelected
                    ? null
                    : () {
                        onAddProduct(productName, clasification,
                            productId); // Pasamos el id aquí
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.grey
                      : const Color.fromARGB(255, 56, 148, 255),
                ),
                child: Text(
                  isSelected ? "Agregado" : "Agregar",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
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
