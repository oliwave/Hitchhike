import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerBitmap {
  MarkerBitmap._(context) {
    _context = context;

    _createBitmap(
      path: 'assets/icons/car/car_white.png',
    ).then((value) {
      print('Get the car bitmap!');
      _car = value;
    });

    _createBitmap(
      path: 'assets/icons/motor/motor_white.png',
    ).then((value) {
      print('Get the motor bitmap!');
      _motor = value;
    });

    _createBitmap(
      path: 'assets/icons/compass/compass.png',
    ).then((value) {
      print('Get the compass bitmap!');
      _compass = value;
    });
  }

  factory MarkerBitmap([BuildContext context]) {
    if (_markerBitmap == null) {
      return _markerBitmap = MarkerBitmap._(context);
    } else {
      return _markerBitmap;
    }
  }

  static MarkerBitmap _markerBitmap;

  Future<BitmapDescriptor> _createBitmap({@required String path}) {
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: MediaQuery.of(_context).devicePixelRatio,
      ),
      path,
    );
  }

  static const String motorText = 'motor';
  static const String carText = 'car';
  static const String compassText = 'compass';

  BuildContext _context;
  BitmapDescriptor _car;
  BitmapDescriptor _motor;
  BitmapDescriptor _compass;

  BitmapDescriptor get car => _car;
  BitmapDescriptor get motor => _motor;
  BitmapDescriptor get compass => _compass;
}
