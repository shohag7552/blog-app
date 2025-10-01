import 'package:flutter/material.dart';

void customSnakeBar(BuildContext context, String? message, {bool isSuccess = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message?? "Default message"),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}