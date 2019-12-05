import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_collection.dart'
    show LocationProvider, HomepageProvider, CloudMessageProvider;

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // MapView will rerender every time but homepage won't.
    // Provider.of<CloudMessageProvider>(
    //   context,
    //   listen: false,
    // ).context = context;

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
    if (homepageProvider.mapFirstRendered) {
      print('First time to listen my position stream');
      locationProvider.locationStreamManager.listenMyPositionStream();
    }

    return Consumer<LocationProvider>(
      builder: (_, locationProvider, child) {
        print('Rerendering the Google map!');
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: 14.4746,
          ),
          compassEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            // locationProvider.futureMapController.complete(controller);
            locationProvider.mapController = controller;
          },
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          markers: Set<Marker>.of(locationProvider.mapComponent.markersValue),
          polylines:
              Set<Polyline>.of(locationProvider.mapComponent.polylinesValue),
          // TODO: This is an alternative solution for updating the google map
          // by implementing 'onTap' callback when users drag it.
          // Instead, we should implement 'onDrag' callback to update.
          onTap: (_) => _onTapMap(locationProvider),
        );
      },
    );
  }

  void _onTapMap(LocationProvider location) {
    location.locationStreamManager.cancelMyPositionStream();
    location.hasMoved = true;
  }
}
