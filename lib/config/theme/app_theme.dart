import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.green.shade50,
    colorSchemeSeed: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}