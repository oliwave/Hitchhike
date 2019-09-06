import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../notify_manager.dart';
import '../../provider/provider_collection.dart'
    show LocationProvider, RoleProvider;
import '../../resources/repository.dart';
import '../../widgets/homepage/google_map_widget/marker_bitmap.dart';

class PairedDataManager extends NotifyManager {
  PairedDataManager({
    @required VoidCallback notifyListeners,
    @required LocationProvider locationProvider,
  })  : _locationProvider = locationProvider,
        super(notifyListeners);

  final LocationProvider _locationProvider;
  final RoleProvider _roleProvider = RoleProvider();
  LatLng _northeast;
  LatLng _southwest;

  LatLng get northeast => _northeast;
  LatLng get southwest => _southwest;

  void initPairingRoute(
    Map<String, dynamic> pairedData, [
    double initialDriverLat,
    double initialDriverLng,
  ]) {
    // Provider waypoint marker for driver and passenger to inspect.
    _locationProvider.mapComponent.createMarker(
      id: Character.passengerStart,
      position: Position(
        latitude: pairedData['legs'][1]['startLat'],
        longitude: pairedData['legs'][1]['startLng'],
      ),
      windowTitle: pairedData['passengerStartName'],
    );

    // Provider waypoint marker for driver and passenger to inspect.
    _locationProvider.mapComponent.createMarker(
      id: Character.passengerEnd,
      position: Position(
        latitude: pairedData['legs'][2]['startLat'],
        longitude: pairedData['legs'][2]['startLng'],
      ),
      windowTitle: pairedData['passengerEndName'],
    );

    _northeast = LatLng(pairedData['northeastLat'], pairedData['northeastLng']);
    _southwest = LatLng(pairedData['southwestLat'], pairedData['southwestLng']);

    // To record all the cooridates of this route.
    List<Position> polyline = [];

    // 1. Store the start location in first leg to polyline.
    polyline.add(
      Position(
        latitude: pairedData['legs'][0]['startLat'],
        longitude: pairedData['legs'][0]['startLng'],
      ),
    );

    if (_roleProvider.role == '司機') {
      // Create `otherSide` marker to distinguishing from `me`.
      if (!_roleProvider.hasRevokedDriverPosition) {
        _locationProvider.mapComponent.createMarker(
          id: Character.otherSide,
          position: Position(
            latitude: pairedData['legs'][1]['startLat'],
            longitude: pairedData['legs'][1]['startLng'],
          ),
          iconName: MarkerBitmap.motor,
        );
      }

      _locationProvider.locationStreamManager
          .listenRevokeDriverPositionStream();

      // 2. Store every end location in each step in every legs to polyline.
      for (final leg in pairedData['legs'])
        for (var step in leg['steps'])
          polyline.add(
            Position(
              latitude: step['endLat'],
              longitude: step['endLng'],
            ),
          );
    } else {
      // Create `otherSide` marker to distinguishing from `me`.
      if (!_roleProvider.hasRevokedDriverPosition) {
        _locationProvider.mapComponent.createMarker(
          id: Character.otherSide,
          position: Position(
            latitude: initialDriverLat ?? pairedData['legs'][0]['startLat'],
            longitude: initialDriverLat ?? pairedData['legs'][0]['startLng'],
          ),
          iconName: MarkerBitmap.car,
        );
      }

      // Only three legs in a route.
      //
      // 2. Store every end location in each step in every legs to polyline
      // instead of the last leg.
      for (int i = 0; i < 3; i++) {
        if (i == 2) break; // Passenger doesn't need the driver's destination.
        for (final step in pairedData['legs'][i]['steps'])
          polyline.add(
            Position(
              latitude: step['endLat'],
              longitude: step['endLng'],
            ),
          );
      }

      // Start to listen driver position stream.
      _locationProvider.locationStreamManager.listenDriverPositionStream();
    }

    // Create polyline with given list of position.
    _locationProvider.mapComponent.createPolyline(
      id: Character.route,
      points: polyline,
    );

    _locationProvider.locationUpdateManager.renderPairingRoute();
  }
}
