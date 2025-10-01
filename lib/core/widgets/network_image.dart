import 'package:flutter/material.dart';

Widget networkImage({required String imageUrl}) {
  return Image.network(
    imageUrl,
    width: double.infinity,
    fit: BoxFit.cover,
    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      if (wasSynchronouslyLoaded) {
        return child;
      }
      return AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: child,
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        color: Colors.black38,
        child: Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: Colors.black38,
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[600],
          size: 64,
        ),
      );
    },
  );
}
