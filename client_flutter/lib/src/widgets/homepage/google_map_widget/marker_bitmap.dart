import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerBitmap {
  MarkerBitmap._(context) {
    _context = context;
    
    _initializeBitmap();
  }

  factory MarkerBitmap([BuildContext context]) {
    if (_markerBitmap == null) {
      return _markerBitmap = MarkerBitmap._(context);
    } else {
      return _markerBitmap;
    }
  }

  static MarkerBitmap _markerBitmap;
  BuildContext _context;

  static const Map<String, String> _raw = {
    motor: 'assets/icons/car/car_white.png',
    car: 'assets/icons/motor/motor_white.png',
    compass: 'assets/icons/compass/compass.png',
  };

  Map<String, BitmapDescriptor> bitmaps = {};
  
  static const String motor = 'motor';
  static const String car = 'car';
  static const String compass = 'compass';

  void _initializeBitmap() {
    _raw.forEach((text, path) {
      _createBitmap(path: path).then((bitmap) {
        print('Get the $text bitmap!');
        bitmaps[text] = bitmap;
      });
    });
  }

  Future<BitmapDescriptor> _createBitmap({@required String path}) {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: MediaQuery.of(_context).devicePixelRatio,
      ),
      path,
    );
  }
}
