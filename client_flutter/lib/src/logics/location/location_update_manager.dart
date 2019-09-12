import 'dart:async';

import 'package:flutter/Material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../notify_manager.dart';
import '../../widgets/homepage/google_map_widget/map_component.dart';
import '../../provider/provider_collection.dart'
    show LocationProvider, RoleProvider;

class LocationUpdateManager extends NotifyManager {
  LocationUpdateManager({
    @required VoidCallback notifyListeners,
    @required LocationProvider locationProvider,
  })  : _locationProvider = locationProvider,
        super(notifyListeners);

  final MapComponent _mapComponent = MapComponent();
  final RoleProvider _roleProvier = RoleProvider();
  final LocationProvider _locationProvider;

  /// Call this method to render the pairing route on google Map.
  ///
  /// However, it usually called when user first get the `pairedData` from
  /// fcm and wanna instantiate the route. Therefore, in general, we usually
  /// call [updateCharacterPosition] to update Google Map instead.
  ///
  /// * Throw `Exception` when this method is not invoked in match mode.
  Future<void> renderPairingRoute() async {
    if (!_roleProvier.isMatched)
      throw Exception(
          'This method can only be invoked when isMatch is true!\n');
    await _updateCameraBounds(
      northeast: _locationProvider.pairedDataManager.northeast,
      southwest: _locationProvider.pairedDataManager.southwest,
    );
  }

  // Update Google Map with geo bounds when the user status is
  // in match mode. Otherwise, only update Google Map with user
  // current location.
  Future<void> updateCharacterPosition({
    @required String character,
    @required Position position,
  }) async {
    _updateMarkerPosition(
      markerId: character,
      position: position,
    );

    if (_roleProvier.isMatched) {
      await _updateCameraBounds(
        northeast: _locationProvider.pairedDataManager.northeast,
        southwest: _locationProvider.pairedDataManager.southwest,
      );
    } else {
      await _updateCameraLatLng(position);
    }

    print('Finish update map position !!!');
  }

  void _updateMarkerPosition({
    @required String markerId,
    @required Position position,
  }) {
    final originalMarker =
        _mapComponent.markers[_mapComponent.markersId[markerId]];

    final updateMarker = originalMarker.copyWith(
      positionParam: LatLng(position.latitude, position.longitude),
      // rotationParam: position.heading - 45,
    );

    _mapComponent.markers[_mapComponent.markersId[markerId]] = updateMarker;
    print('Update marker $markerId position ... ');
  }

  Future<void> _updateCameraLatLng(Position position) async {
    // final controller = await _locationProvider.futureMapController.future;
    final controller = _locationProvider.mapController;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        // 16.0,
        14.4746,
      ),
    );
    print('Animate camera ... ');
  }

  Future<void> _updateCameraBounds({
    @required LatLng northeast,
    @required LatLng southwest,
  }) async {
    // final controller = await _locationProvider.futureMapController.future;
    final controller = _locationProvider.mapController;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: northeast,
          southwest: southwest,
        ),
        5.0,
      ),
    );
  }
}
