import 'package:flutter/material.dart';

class ViewUtil {
  static void showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );

  static void cleanSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context)..hideCurrentSnackBar();
}
