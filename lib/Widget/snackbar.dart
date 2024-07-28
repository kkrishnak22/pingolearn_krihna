import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning }

void showSnackBar(BuildContext context, String text, SnackBarType type) {
  Color backgroundColor;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
