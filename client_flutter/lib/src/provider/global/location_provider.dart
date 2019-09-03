import 'dart:async';

import 'package:client_flutter/src/resources/repository.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../resources/repository.dart' show Character;
import '../../logics/location/location_stream_manager.dart';
import '../../logics/location/location_update_manager.dart';
import '../../widgets/homepage/google_map_widget/map_component.dart';
import '../../widgets/homepage/google_map_widget/marker_bitmap.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider._() {
    _managerInit();
  }

  factory LocationProvider() => _locationProvider;

  static final _locationProvider = LocationProvider._();

  final _geolocator = Geolocator();

  final mapComponent = MapComponent();

  LocationUpdateManager _locationUpdateManager;
  LocationStreamManager _locationStreamManager;

  Position _initPosition;

  LocationUpdateManager get locationUpdateManager => _locationUpdateManager;
  LocationStreamManager get locationStreamManager => _locationStreamManager;

  /// A very basis method called whenever clients need to get
  /// a up-to-date position.
  Future<Position> get currentPosition async =>
      await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

  /// When launching the application, the client can use [_initPosition]
  /// as the starting point for the map.
  Position get initialPosition => _initPosition;

  /// This method only needs to be called once at the launching stage,
  /// in order to get current initialization location and instantiate
  /// map gadgets.
  Future<void> initializePosition() async {
    if (_initPosition != null) {
      print('initPosition has been called!');
      return;
    }

    _initPosition = await currentPosition;

    _initializeMapGadget();

    print('Initial position has been resolved!');
  }

  /// Initialize [Marker] and [Cicrle] to indicate the current location of user.
  void _initializeMapGadget() {
    mapComponent.createCircle(
      id: Character.me,
      position: _initPosition,
      color: Colors.blue[100].withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.blue[500],
    );

    mapComponent.createMarker(
      id: Character.me,
      iconName: MarkerBitmap.compass,
      position: _initPosition,
    );
  }

  void _managerInit() {
    _locationUpdateManager = LocationUpdateManager(
      notifyListeners: _registerNotifyListeners,
    );
    _locationStreamManager = LocationStreamManager(_registerNotifyListeners);
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
