import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../resources/repository.dart';
import '../../logics/location/location_stream_manager.dart';
import '../../logics/location/location_update_manager.dart';
import '../../logics/location/paired_data_manager.dart';
import '../../widgets/homepage/google_map_widget/map_component.dart';
import '../../widgets/homepage/google_map_widget/marker_bitmap.dart';
import '../provider_collection.dart' show RoleProvider;

class LocationProvider extends ChangeNotifier {
  LocationProvider._() {
    _managerInit();
  }

  factory LocationProvider() => _locationProvider;

  static final _locationProvider = LocationProvider._();

  final _geolocator = Geolocator();
  final _roleProvider = RoleProvider();
  final _fs = Repository.getJsonFileHandler;
  final mapComponent = MapComponent();

  LocationUpdateManager _locationUpdateManager;
  LocationStreamManager _locationStreamManager;
  PairedDataManager _pairedDataManager;

  Position _initPosition;

  LocationUpdateManager get locationUpdateManager => _locationUpdateManager;
  LocationStreamManager get locationStreamManager => _locationStreamManager;
  PairedDataManager get pairedDataManager => _pairedDataManager;

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

    await _initializeMapGadget();

    print('Initial position has been resolved!');
  }

  /// Initialize [Marker] and [Cicrle] to indicate the current location of user.
  Future<void> _initializeMapGadget() async {
    if (_roleProvider.isMatched) {
      // Read data from json file.
      final pairedData = await _fs.readFile(
        fileName: FileName.pairedData,
      );

      _pairedDataManager.initPairingRoute(
        pairedData,
        // Specify initial position for driver marker.
        _roleProvider.driverLat,
        _roleProvider.driverLng,
      );
    }

    mapComponent.createMarker(
      id: Character.me,
      iconName: MarkerBitmap.compass,
      position: _initPosition,
    );
  }

  void _managerInit() {
    _locationUpdateManager = LocationUpdateManager(
      notifyListeners: _registerNotifyListeners,
      locationProvider: this,
    );
    _locationStreamManager = LocationStreamManager(
      notifyListeners: _registerNotifyListeners,
      locationProvider: this,
    );
    _pairedDataManager = PairedDataManager(
      notifyListeners: _registerNotifyListeners,
      locationProvider: this,
    );
  }

  void _registerNotifyListeners() {
    notifyListeners();
  }
}
