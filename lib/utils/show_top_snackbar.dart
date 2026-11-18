import 'package:flutter/material.dart';

void showTopSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  required Color backgroundColor,
}) {
  final screenHeight = MediaQuery.of(context).size.height;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: EdgeInsets.fromLTRB(16, 0, 16, screenHeight - 160),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(message),
          ],
        ),
      ),
    );
}
