import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  static final _geolocator = Geolocator();
  static final locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Future<Position> get currentPosition async =>
      await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
}
