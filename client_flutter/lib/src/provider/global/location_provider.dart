import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/homepage/google_map_widget/map_component.dart';
import '../../widgets/homepage/google_map_widget/marker_bitmap.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider._();

  factory LocationProvider() {
    return _locationProvider;
  }

  static final _locationProvider = LocationProvider._();

  final Completer<GoogleMapController> mapController = Completer();
  final MapComponent mapComponent = MapComponent();
  final _geolocator = Geolocator();
  final _locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );
  StreamSubscription<Position> _positionStream;

  /// WARNING : Only for testing
  Position _positionInfo;

  /// A very basis method called whenever clients need to get
  /// a up-to-date position.
  Future<Position> get currentPosition async =>
      await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

  /// Initialize [Marker] and [Cicrle] to indicate the current location of user.
  Future<Position> get initialPosition async {
    final position = await currentPosition;

    mapComponent.createCircle(
      id: 'me',
      position: position,
      color: Colors.blue[100].withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.blue[500],
    );

    mapComponent.createMarker(
      id: 'me',
      iconName: MarkerBitmap.compass,
      position: position,
    );

    return position;
  }

  /// WARNING : Only for testing
  Position get positionInfo => _positionInfo;

  /// WARNING : Only for testing
  set positionInfo(Position position) {
    _positionInfo = position;
    notifyListeners();
  }

  /// This method will subscribe the position Stream, so every time when an event
  /// emits, we have to update the google map with the latest position.
  void activatePositionStream() {
    _positionStream = _geolocator
        .getPositionStream(_locationOptions)
        .listen((position) async {
      positionInfo = position; // WARNING : Only for testing

      print(
        'activatePositionStream has been triggered!!!\n'
        'The latitude of position stream is ${position.latitude}\n'
        'The heading of position stream is ${position.heading}',
      );
      await _updateMapPosition(position);
    });
  }

  /// This method enable client to unsubscrible the position Stream at any time.
  void cancelPositionStream() {
    print('Just triggered cancelPositionStream!!! on tap');
    _positionStream.cancel();
  }

  Future<void> _updateMapPosition(Position position) async {
    _updateMarkerPosition(position, 'me');
    _updateCirclePosition(position, 'me');
    await _updateCameraLatLng(position);
    print('Finish update map position !!!');
  }

  void _updateMarkerPosition(Position position, String markerId) {
    final updateMarker =
        mapComponent.markers[mapComponent.markersId[markerId]].copyWith(
      positionParam: LatLng(position.latitude, position.longitude),
      rotationParam: position.heading - 45,
    );

    mapComponent.markers[mapComponent.markersId[markerId]] = updateMarker;
    print('Update marker position ... ');
  }

  void _updateCirclePosition(Position position, String circleId) {
    final updateCircle =
        mapComponent.circles[mapComponent.circlesId[circleId]].copyWith(
      centerParam: LatLng(position.latitude, position.longitude),
    );

    mapComponent.circles[mapComponent.circlesId[circleId]] = updateCircle;
    print('Update circle position ... ');
  }

  Future<void> _updateCameraLatLng(Position position) async {
    final controller = await mapController.future;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15,
        // 14.4746,
      ),
    );
    print('Animate camera ... ');
  }
}
