import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String? imageUrl;
  final Widget content;
  final List<Widget>? actions;

  const ListItem({
    super.key,
    this.imageUrl,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: _getImageProvider(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (imageUrl != null) const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    if (actions != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.grey,
        ),
      ],
    );
  }

  ImageProvider _getImageProvider() {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return NetworkImage(imageUrl!);
    } else if (imageUrl != null) {
      return AssetImage(imageUrl!);
    } else {
      return const AssetImage('assets/placeholder.png');
    }
  }
}
