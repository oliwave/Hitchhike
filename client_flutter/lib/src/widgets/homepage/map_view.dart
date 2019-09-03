import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart'
    show LocationProvider, HomepageProvider;

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Refreshing MapView ...');

    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final homepageProvider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    final position = locationProvider.initialPosition;

    // acitvatePositionStream method to keep the latest position on the map.
    locationProvider.locationStreamManager.listenMyPositionStream();

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: 14.4746,
      ),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        locationProvider.locationUpdateManager.mapController
            .complete(controller);
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(locationProvider.mapComponent.markersValue),
      circles: Set<Circle>.of(locationProvider.mapComponent.circlesValue),
      polylines: Set<Polyline>.of(locationProvider.mapComponent.polylinesValue),
      // TODO: This is an alternative solution for updating the google map
      // by implementing 'onTap' callback when users drag it.
      // Instead, we should implement 'onDrag' callback to update.
      onTap: (_) => _onTapMap(locationProvider, homepageProvider),
    );
  }

  void _onTapMap(LocationProvider location, HomepageProvider homepage) {
    location.locationStreamManager.cancelMyPositionStream();
    homepage.hasMoved = true;
  }
}
