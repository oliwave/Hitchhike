import 'package:flutter/material.dart';

class PlatformInfo {

  PlatformInfo._();

  static const double _baseHeight = 650.0;

  static BuildContext context;

  static double screenAwareSize(double size) {
    // final height = size * MediaQuery.of(context).size.height / _baseHeight;
    final height = size * 1.19;
    // print(height);
    return height;
  }
}
