import 'package:flutter/material.dart';

class CardsListar extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onVisibilityTap;
  final VoidCallback onEditTap;

  const CardsListar({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onVisibilityTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onVisibilityTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(112, 185, 244, 1),
                  ),
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(112, 185, 244, 1),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
