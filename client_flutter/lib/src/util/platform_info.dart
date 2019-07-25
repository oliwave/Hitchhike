import 'package:flutter/material.dart';

class PlatformInfo {

  PlatformInfo._();

  static const double _baseHeight = 650.0;

  static BuildContext context;

  static double screenAwareSize(double size) {
    return size * MediaQuery.of(context).size.height / _baseHeight;
  }
}
