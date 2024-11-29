import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String price;
  final String units;
  final String additionalInfo;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.units,
    required this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 209, 234, 255),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.10,
          height: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
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
                additionalInfo,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                units,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
