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
  // final Completer<GoogleMapController> _futureMapController = Completer();
  GoogleMapController mapController;

  LocationUpdateManager _locationUpdateManager;
  LocationStreamManager _locationStreamManager;
  PairedDataManager _pairedDataManager;

  /// Used to detect whether the google map has been dragged.
  bool _hasMoved = false;

  Position _initPosition;

  LocationUpdateManager get locationUpdateManager => _locationUpdateManager;
  LocationStreamManager get locationStreamManager => _locationStreamManager;
  PairedDataManager get pairedDataManager => _pairedDataManager;

  /// The field will be set with true when clients tap on the Google map.
  bool get hasMoved => _hasMoved;
  // Completer<GoogleMapController> get futureMapController =>
  //     _futureMapController;

  /// A very basic method called whenever clients need to get
  /// an up-to-date position.
  Future<Position> get currentPosition async =>
      await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

  /// When launching the application, the client can use [_initPosition]
  /// as the starting point for the map.
  Position get initialPosition => _initPosition;

  set hasMoved(bool moved) {
    _hasMoved = moved;
    notifyListeners();
  }

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
      // The current time is before the endTimeOfTrip
      if (_roleProvider.endTimeOfTrip.isAfter(DateTime.now())) {

        print('_roleProvider.endTimeOfTrip is ${_roleProvider.endTimeOfTrip}');
        print('now is ${DateTime.now()}');

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
      } else {
        // The current time is after the endTimeOfTrip
        _roleProvider.clearCache();
      }
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
