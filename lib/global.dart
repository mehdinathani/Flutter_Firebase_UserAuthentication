import 'dart:js';

import 'package:flutter/material.dart';

void showSnackbar(String message) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    content: Text(message),
  );
  ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
}
