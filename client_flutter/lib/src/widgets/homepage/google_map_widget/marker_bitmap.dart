import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerBitmap {
  MarkerBitmap._();

  factory MarkerBitmap() => _markerBitmap;

  static final MarkerBitmap _markerBitmap = MarkerBitmap._();
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

  Future<void> initializeBitmap(BuildContext context) async {
    if (bitmaps.isNotEmpty) return;
    _context = context;
    print('Initialize the MarkerBitmap!');

    final text = _raw.keys.toList();
    final path = _raw.values.toList();

    for (int i = 0; i < text.length; i++) {
      final target = text[i];
      bitmaps[target] = await _createBitmap(path: path[i]);
      print('Get the $target bitmap!');
    }
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
