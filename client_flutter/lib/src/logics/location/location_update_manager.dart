import 'dart:async';

import 'package:client_flutter/src/logics/notify_manager.dart';
import 'package:flutter/Material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/homepage/google_map_widget/map_component.dart';

class LocationUpdateManager extends NotifyManager {
  LocationUpdateManager._(VoidCallback notifyListeners)
      : super(notifyListeners);

  factory LocationUpdateManager({VoidCallback notifyListeners}) {
    if (_locationUpdateManager != null) {
      return _locationUpdateManager;
    }
    return _locationUpdateManager = LocationUpdateManager._(notifyListeners);
  }

  static LocationUpdateManager _locationUpdateManager;
  final MapComponent _mapComponent = MapComponent();
  final Completer<GoogleMapController> mapController = Completer();

  Future<void> updateCharacterPosition({
    @required String character,
    @required Position position,
  }) async {
    _updateMarkerPosition(
      markerId: character,
      position: position,
    );
    _updateCirclePosition(
      position: position,
      circleId: character,
    );
    await _updateCameraLatLng(position);
    print('Finish update map position !!!');
  }

  void _updateMarkerPosition({
    @required Position position,
    @required String markerId,
  }) {
    final updateMarker =
        _mapComponent.markers[_mapComponent.markersId[markerId]].copyWith(
      positionParam: LatLng(position.latitude, position.longitude),
      rotationParam: position.heading - 45,
    );

    _mapComponent.markers[_mapComponent.markersId[markerId]] = updateMarker;
    print('Update marker position ... ');
  }

  void _updateCirclePosition({
    @required Position position,
    @required String circleId,
  }) {
    final updateCircle =
        _mapComponent.circles[_mapComponent.circlesId[circleId]].copyWith(
      centerParam: LatLng(position.latitude, position.longitude),
    );

    _mapComponent.circles[_mapComponent.circlesId[circleId]] = updateCircle;
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
