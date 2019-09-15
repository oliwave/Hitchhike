import 'package:flutter/material.dart';


class SizeConfig {
  SizeConfig._();

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _blockSizeHorizontal;
  static double _blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double _safeBlockHorizontal;
  static double _safeBlockVertical;

  static double screenSafeAwareWidth(double proportion) {
    return _safeBlockHorizontal * proportion;
  }

  static double screenSafeAwareHeight(double proportion) {
    return _safeBlockVertical * proportion;
  }

  static double screenAwareWidth(double proportion) {
    return _blockSizeHorizontal * proportion;
  }

  static double screenAwareHeight(double proportion) {
    return _blockSizeVertical * proportion;
  }

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;

    print('SizeConfig has been initialized');
  }
}

// class PlatformInfo {
//   PlatformInfo._();

//   // static const double _baseHeight = 650.0;

//   static BuildContext context;

//   static double screenAwareSize(double size) {
//     // final height = size * MediaQuery.of(context).size.height / _baseHeight;
//     final height =
//         size * (MediaQuery.of(context).size.height > 650 ? 1.2 : 1.1);
//     // print(height);
//     return height;
//   }
// }