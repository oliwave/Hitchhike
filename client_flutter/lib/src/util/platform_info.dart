import 'package:flutter/material.dart';

class PlatformInfo {
  PlatformInfo._();

  // static const double _baseHeight = 650.0;

  static BuildContext context;

  static double screenAwareSize(double size) {
    // final height = size * MediaQuery.of(context).size.height / _baseHeight;
    final height = size * (MediaQuery.of(context).size.height > 650 ? 1.2 : 1.1);
    // print(height);
    return height;
  }
}
